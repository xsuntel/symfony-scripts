---
name: documentation-generator
description: Use to auto-generate API endpoint documentation, write OpenAPI specs, or create request/response examples for external provider integrations (KoreaInvestment, UPbit, ECOS, KOSIS, VWorld, etc.).
---

# API Documentation Generation

## Accuracy Principle

For information that cannot be verified against the current codebase or the official documentation, use hedged wording such as:

- "This configuration value needs to be cross-checked against the official documentation."
- "The behavior may vary by version, so check the release notes."
- "This behavior may differ depending on the environment."

Never state API versions, defaults, or error codes assertively when they are not confirmed by a source.

## Prohibitions

- Do not present unverified API version information as fact.
- Do not present untested configuration values as if they were defaults.
- Do not invent error codes or response schemas by guessing.
- Do not document endpoints that do not exist in the current codebase or the official provider documentation.

## Endpoint Investigation

Before writing documentation, always confirm the actual implementation location first:

1. Find the `MessageCommandHandler` that calls the endpoint via `HttpClientInterface`.
2. Confirm the scoped HTTP client in `config/packages/framework.yaml` (`framework.http_client.scoped_clients`).
3. Read the provider DTO that deserializes the response.
4. Read the corresponding `Entity` to confirm which fields are persisted.

Only after this 4-step investigation can you guarantee that the documented request/response matches what the actual code exchanges.

## Documentation Structure

For each endpoint, write the following sections in order:

### 1. Overview

```
Provider    : KoreaInvestment / UPbit / ECOS / KOSIS / VWorld
TR ID       : (e.g. FHKST01010100)
Method      : GET | POST
Path        : /uapi/domestic-stock/v1/...
Auth        : OAuth2 Bearer | API Key | None
Rate Limit  : X req/sec, Y req/day
```

### 2. Authentication

Document the exact authentication method used in this project:

- **ECOS / KOSIS / VWorld** — pass the API key as a query parameter, taking the key from an environment variable (`APP_ECOS_KEY`, etc.).

Never document the decrypted key value — show only a masked prefix (`ABCD****`).

### 3. Request

```yaml
# Headers
Authorization: Bearer {access_token}
appkey: {app_key}
appsecret: {secret_key}
tr_id: FHKST01010100
Content-Type: application/json; charset=utf-8

# Query / Body Parameters
market_code: KRW-BTC   # string, required — market identifier
```

Include only the parameters that appear in the actual HTTP call. Mark each field as `required` or `optional`.

### 4. Response

Document only the fields mapped to a Doctrine `Entity` or used in downstream logic:

```json
{
  "rt_cd": "0",
  "msg_cd": "MAPIKEY010000",
  "msg1": "Inquiry successful",
  "output": {
    "market": "KRW-BTC",
    "trade_price": "85000000",
    "acc_trade_volume": "123.45678901"
  }
}
```

Distinguish between fields stored verbatim in a `json`/`jsonb` column and fields mapped to individual typed columns.

### 5. Error Codes

List only the error codes that appear in the provider's official documentation or that are actually handled (`catch` blocks, retry logic) in the codebase. Do not invent codes.

| Code | Meaning | How it is handled in the project |
|------|------|-----------------|
| `EGW00001` | Authentication failure | Dispatch a `MessageEvent` → notify the user via Notifier; no retry |
| `APBK0013` | Rate limit exceeded | Re-throw as `\RuntimeException`; RabbitMQ retries up to `max_retries` |

### 6. Rate Limiting

Document the lock key pattern used in this project:

```
Lock key: lock_{provider}_{tr_id}
Example : lock_korea_investment_FHKST01010100
Strategy: Symfony Lock sliding-window guard before each HTTP dispatch
```

### 7. Persistence Notes

State which `Entity` stores this endpoint's response and how:

```
Entity   : App\Entity\Providers\Finance\App\Securities\KoreaInvestment\Domestic\Stock\...
Table    : api_rest_quotation_ticker_ticker
Raw JSON : stored in `output` column (type: json → PostgreSQL jsonb)
Typed    : market (string PK), trade_price (decimal), acc_trade_volume (decimal)
```

## OpenAPI Spec Output Format

When asked to write an OpenAPI 3.1 spec, use YAML format. Extract shared types into `$ref` schemas rather than inlining them. Mark a field `nullable` only when the actual API response can return `null` for it.

```yaml
openapi: "3.1.0"
info:
  title: KoreaInvestment Domestic Stock API
  version: "1.0.0"
paths:
  /uapi/domestic-stock/v1/quotations/inquire-price:
    get:
      summary: Inquire current price
      parameters:
        - name: FID_COND_MRKT_DIV_CODE
          in: query
          required: true
          schema:
            type: string
            example: J
      responses:
        "200":
          description: Success
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/InquirePriceResponse"
```

## Scheduler Task Documentation

For endpoints invoked by `#[AsPeriodicTask]`, document the schedule and the market-time guard logic together:

```
Scheduler class : App\Scheduler\Providers\Finance\App\Securities\KoreaInvestment\Domestic\...
Frequency       : every 30 seconds during market hours
Market guard    : checks ChkHoliday entity + Yasumi before dispatching Command
Command         : App\MessageCommand\Providers\Finance\...
EntityManager   : providers_finance_app_securities_koreainvestment_domestic
Migration cmd   : php bin/console doctrine:migrations:migrate --em=providers_finance_app_securities_koreainvestment_domestic
```
