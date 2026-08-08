---
description: "Runs a procedural functional test against API Platform (Symfony) resources."
argument-hint: "[path to the resource/file to test (defaults to the full standard procedure)]"
---

Verify the following API Platform test target:

**`$1`**

If no argument is given, run the standard procedure across all resources in `app/src/ApiResource/`.
The single source of truth (SoT) for the test criteria is the rule file, and the work proceeds on
`ApiPlatform\Symfony\Bundle\Test\ApiTestCase`.

@see .claude/rules/api/base/api-platform-rule.md — API Platform rules (SoT, `## Testing` section)
@see .claude/rules/app/base/php-symfony/09-testing-rule.md — test layer strategy
@see https://api-platform.com/docs/symfony/testing/ — ApiTestCase official docs

## Test Procedure

For each operation of each resource, cover the following:

1. **Collection retrieval** (`GetCollection`) — `assertResponseIsSuccessful()`,
   `assertMatchesResourceCollectionJsonSchema(Resource::class)`.
2. **Single retrieval** (`Get`) — present/absent (404), `assertMatchesResourceItemJsonSchema(Resource::class)`.
3. **Create** (`Post`) — success (`assertResponseStatusCodeSame(201)` + `assertJsonContains`),
   validation failure (422 + RFC 7807/Hydra error body, verifying the per-operation `validationContext` groups are reflected), authorization denial (401/403).
4. **Update** (`Patch`) — verify the partial update is reflected, and that invalid/out-of-group fields are ignored.
5. **Delete** (`Delete`) — `assertResponseStatusCodeSame(204)`, re-fetch 404.
6. **Filters & pagination** (`GetCollection`) — verify result narrowing/sorting with parameter-based filter (`#[QueryParameter]`) queries (`?title=...` partial, `?order=desc` sort, `?price[gte]=10` comparison), and verify pagination metadata (`hydra:totalItems`/`view`) and the `itemsPerPage` upper-bound behavior.
7. **Error format** — verify with `assertJsonContains` that validation failures (422) and domain-exception responses follow the RFC 7807/Hydra structure (`type`/`title`/`detail`/`violations` or `hydra:description`), and check the mapped status code.
8. **Async operations** (`messenger:`) — verify `assertResponseStatusCodeSame(202)` and, when `output: false`, that the body is not serialized. When needed, verify the message dispatch with Messenger test helpers such as `transport('...')->queue()`.

## Execution

```bash
cd app && vendor/bin/phpunit --testsuite Functional
cd app && vendor/bin/phpunit tests/Functional/ApiResource
```

## Test Skeleton

```php
use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;

final class BookResourceTest extends ApiTestCase
{
    public function testGetCollection(): void
    {
        static::createClient()->request('GET', '/api/books');

        $this->assertResponseIsSuccessful();
        $this->assertMatchesResourceCollectionJsonSchema(BookResource::class);
    }

    public function testCreateValidationError(): void
    {
        static::createClient()->request('POST', '/api/books', ['json' => []]);

        $this->assertResponseStatusCodeSame(422);
    }
}
```

For resources with JWT/stateless authentication, pass the Bearer token as a header (reuse token
issuance/caching via an `AbstractTest` base — see the `## Testing` section of the rules):

```php
static::createClient([], ['headers' => ['Authorization' => 'Bearer ' . $token]])
    ->request('POST', '/api/books', ['json' => ['title' => 'A']]);
```

## Output Format

Summarize operation × case (success/validation-failure/authorization-denied/absent) in a table, and
for failing items present the request, expectation, and actual response together.
