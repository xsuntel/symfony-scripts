# PHP / Symfony — Technical Specification

This document provides the **detailed reference and code templates** for PHP coding standards,
architecture, and domain structure. The enforced judgment criteria (SoT) are the rule files, and this
document holds their detailed/example edition — if there is a conflict with the rules, the rules take precedence.

@see .claude/rules/app/base/php-symfony/00-overview-rule.md ~ 11-performance-rule.md — judgment criteria (SoT)
@see .claude/rules/structure-rule.md — directory & path context

---

## 1. Technical Environment

| Item | Version / Setting |
| --- | --- |
| PHP | 8.4 (strict_types required) — local CLI is 8.5 but the code target is 8.4 |
| Symfony | 8.0.x Framework (`composer.json`: `symfony/framework-bundle: 8.0.*`) |
| Doctrine ORM | 3.x (PHP attribute-based mapping) |
| Static analysis | PHPStan level 8 (`app/phpstan.dist.neon`) |
| Code style | PHP-CS-Fixer (`app/.php-cs-fixer.dist.php`, Symfony ruleset) |
| Testing | PHPUnit (`app/phpunit.xml.dist`) |
| Source root | `app/src/` (namespace: `App\`) |
| Templates | `app/templates/` (Twig) |

---

## 2. File Header and Coding Standards

### 2.1 Required Header Structure

Every PHP file follows this order.

```php
<?php

declare(strict_types=1);

namespace App\Domain\SubDomain;

use DateTimeImmutable;                          // Group 1: PHP built-in
use InvalidArgumentException;

use Doctrine\ORM\Mapping as ORM;               // Group 2: Doctrine
use Doctrine\Common\Collections\Collection;

use Symfony\Component\Routing\Attribute\Route; // Group 3: Symfony
use Symfony\Component\Validator\Constraints as Assert;

use App\Domain\Order\Entity\Order;              // Group 4: App
use App\Domain\Order\Repository\OrderRepository;
```

Rules:

- One blank line after `<?php`, then `declare(strict_types=1)`
- **No** closing `?>` tag (except template files)
- Separate `use` groups with a blank line, sort alphabetically within a group
- 4-space indentation, no tabs
- Soft line limit of 120 characters

### 2.2 Namespace ↔ Path Mapping (PSR-4)

| Path | Namespace |
| --- | --- |
| `app/src/Domain/Order/Entity/Order.php` | `App\Domain\Order\Entity` |
| `app/src/Domain/Order/Repository/OrderRepository.php` | `App\Domain\Order\Repository` |
| `app/src/Controller/Api/OrderController.php` | `App\Controller\Api` |
| `app/src/Scheduler/Finance/DailyReportScheduler.php` | `App\Scheduler\Finance` |

---

## 3. PHP 8.4 Modern Features

### 3.1 Constructor Property Promotion

Dependency injection properties must use promotion syntax. The separate-declaration + constructor-assignment pattern is **prohibited**.

```php
// Prohibited
class OrderService
{
    private readonly OrderRepository $repository;

    public function __construct(OrderRepository $repository)
    {
        $this->repository = $repository;
    }
}

// Recommended
final class OrderService
{
    public function __construct(
        private readonly OrderRepository $repository,
        private readonly LoggerInterface $logger,
    ) {}
}
```

### 3.2 readonly Property / readonly class

Declare `readonly` on properties that do not change after construction.
Declare a class where all properties are readonly as a `readonly class`.

```php
// DTOs and value objects are readonly class
readonly class CreateOrderCommand
{
    public function __construct(
        public string $customerId,
        public string $productId,
        public int    $quantity,
    ) {}
}

// Entities apply readonly to individual properties
final class Order
{
    public function __construct(
        #[ORM\Id]
        #[ORM\Column(type: 'uuid')]
        public readonly string $id,

        #[ORM\Column(type: Types::DATETIME_IMMUTABLE, nullable: false)]
        public readonly DateTimeImmutable $createdAt,
    ) {}
}
```

### 3.3 match Expression

Replace a `switch` that maps values completely to return values with `match`.
`match` uses strict comparison (`===`) and throws `UnhandledMatchError` on an unhandled case.

```php
// Prohibited
switch ($status) {
    case 'pending':  $label = 'Pending'; break;
    case 'approved': $label = 'Approved'; break;
    default:         $label = 'Unknown';
}

// Recommended
$label = match($status) {
    'pending'  => 'Pending',
    'approved' => 'Approved',
    default    => throw new InvalidArgumentException("Unknown status: {$status}"),
};
```

### 3.4 Backed Enum

Define related sets of constants (status, type, role, category) as an `enum`.

```php
// Prohibited
class OrderStatus
{
    public const PENDING  = 'pending';
    public const APPROVED = 'approved';
    public const REJECTED = 'rejected';
}

// Recommended
enum OrderStatus: string
{
    case Pending  = 'pending';
    case Approved = 'approved';
    case Rejected = 'rejected';

    public function label(): string
    {
        return match($this) {
            self::Pending  => 'Pending',
            self::Approved => 'Approved',
            self::Rejected => 'Rejected',
        };
    }
}
```

Doctrine column mapping:

```php
#[ORM\Column(type: Types::STRING, enumType: OrderStatus::class, nullable: false)]
private OrderStatus $status = OrderStatus::Pending;
```

### 3.5 Nullsafe Operator

```php
// Prohibited
$city = $user ? ($user->getAddress() ? $user->getAddress()->getCity() : null) : null;

// Recommended
$city = $user?->getAddress()?->getCity();
```

### 3.6 Named Arguments

Use named arguments to improve readability for calls with several optional parameters.

```php
// Prohibited
$this->cache->get('key', null, 3600, true);

// Recommended
$this->cache->get(key: 'key', tags: null, ttl: 3600, checkLockTimeout: true);
```

### 3.7 Property Hooks (PHP 8.4)

Replace verbose getter/setter pairs for computed/validated properties with `get`/`set` hooks.

```php
final class Product
{
    public string $name {
        get => strtoupper($this->name);
        set(string $value) {
            if (strlen($value) < 2) {
                throw new InvalidArgumentException('Name too short');
            }
            $this->name = $value;
        }
    }
}
```

### 3.8 Asymmetric Visibility (PHP 8.4)

Use when a property should be readable externally but writable only inside the class.

```php
final class Order
{
    // public read, private write
    public private(set) OrderStatus $status = OrderStatus::Pending;

    public function approve(): void
    {
        $this->status = OrderStatus::Approved; // only possible internally
    }
}
```

---

## 4. Type Safety and Static Analysis

### 4.1 Required Type Declarations

Declare parameter types and return types on every method.

```php
// Prohibited
public function process($order)
{
    return $order->getId();
}

// Recommended
public function process(Order $order): string
{
    return $order->getId();
}
```

Return type special cases:

- No return value → `void`
- Only throws an exception → `never`
- The class itself → `static` (fluent interface) or `self`
- Nullable → `Type|null` (more explicit than the shorthand `?Type`)

### 4.2 No mixed

`mixed` defeats static analysis. Replace it with the most specific union type possible.

```php
// Prohibited
public function getValue(): mixed { }

// Recommended
public function getValue(): string|int|null { }
```

### 4.3 PHPDoc Usage Criteria

Add PHPDoc only when the native types cannot express it.

```php
// Needed: to express the array element type
/** @return Order[] */
public function findByStatus(OrderStatus $status): array { }

/** @param array<string, mixed> $context */
public function log(string $message, array $context): void { }

// Unnecessary: the native type is already stated
/** @return string */  // ← redundant — remove
public function getName(): string { }
```

### 4.4 PHPStan level 8 Compliance

```bash
cd app && vendor/bin/phpstan analyse
```

Main errors detected at level 8:

- Accessing a nullable property without a null check
- Calling a method with incompatible argument types
- Unreachable code paths
- Missing `@return Order[]` PHPDoc when returning an `array`

---

## 5. Class Design and Architecture

### 5.1 final Class

Every concrete class not designed for extension must be `final`.

Applies to: `Service`, `Handler`, `EventSubscriber`, `Controller`, `Repository`, `Scheduler`

```php
final class OrderService { }
final class CreateOrderHandler { }
final class OrderEventSubscriber { }
```

Exceptions: abstract classes (`abstract`), interfaces, test double base classes.

### 5.2 Single Responsibility Principle

- Class exceeds ~200 lines → consider splitting responsibilities
- More than ~7 public methods → possible SRP violation

### 5.3 Immutability

Use `readonly class` for DTOs and value objects.

```php
readonly class MoneyValue
{
    public function __construct(
        public int    $amount,
        public string $currency,
    ) {}

    public function add(MoneyValue $other): self
    {
        // return a new instance — do not mutate the existing one
        return new self($this->amount + $other->amount, $this->currency);
    }
}
```

### 5.4 No new in the Constructor

```php
// Prohibited
public function __construct()
{
    $this->client = new HttpClient(); // should be injected via DI
}

// Recommended
public function __construct(
    private readonly HttpClientInterface $client,
) {}
```

---

## 6. Dependency Injection and Symfony Conventions

### 6.1 Constructor Injection Only

Setter injection, property injection, and `$container->get()` calls are **prohibited**.

```php
// Prohibited
public function setLogger(LoggerInterface $logger): void
{
    $this->logger = $logger;
}

// Recommended
public function __construct(
    private readonly LoggerInterface $logger,
) {}
```

### 6.2 #[Autowire] Attribute

Use for injecting scalar values, environment variables, and parameters.

```php
use Symfony\Component\DependencyInjection\Attribute\Autowire;

final class PaymentService
{
    public function __construct(
        #[Autowire('%kernel.debug%')]
        private readonly bool $debug,

        #[Autowire(env: 'PAYMENT_API_KEY')]
        private readonly string $apiKey,

        #[Autowire(service: 'cache.app')]
        private readonly CacheInterface $cache,
    ) {}
}
```

### 6.3 #[Target] Attribute

Use to specify a particular service among multiple implementations of the same interface.

```php
use Symfony\Component\DependencyInjection\Attribute\Target;

final class OrderService
{
    public function __construct(
        #[Target('monolog.logger.order')]
        private readonly LoggerInterface $logger,
    ) {}
}
```

### 6.4 Attribute-Based Routing and Security

Use PHP attributes instead of YAML/XML configuration.

```php
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[Route('/api/v1/orders', name: 'api_orders_')]
#[IsGranted('ROLE_USER')]
final class OrderController extends AbstractController
{
    #[Route('', name: 'list', methods: ['GET'])]
    public function list(): JsonResponse { }

    #[Route('/{id}', name: 'show', methods: ['GET'])]
    #[IsGranted('view', 'order')]
    public function show(Order $order): JsonResponse { }

    #[Route('', name: 'create', methods: ['POST'])]
    #[IsGranted('ROLE_ADMIN', methods: ['POST'])]
    public function create(Request $request): JsonResponse { }
}
```

### 6.5 Thin Controllers

A controller only parses input → calls a service/handler → returns a response.
Delegate business logic to a dedicated Service or MessageCommandHandler.

```php
#[Route('/api/v1/orders', methods: ['POST'])]
public function create(Request $request, MessageBusInterface $bus): JsonResponse
{
    $dto = $this->serializer->deserialize($request->getContent(), CreateOrderDto::class, 'json');
    $errors = $this->validator->validate($dto);

    if (count($errors) > 0) {
        return $this->json(['errors' => (string) $errors], 422);
    }

    $bus->dispatch(new CreateOrderCommand(
        customerId: $dto->customerId,
        productId:  $dto->productId,
        quantity:   $dto->quantity,
    ));

    return $this->json(null, 202);
}
```

---

## 7. Doctrine ORM

### 7.1 Required Entity Mapping Elements

```php
#[ORM\Entity(repositoryClass: OrderRepository::class)]
#[ORM\Table(name: 'orders')]
#[ORM\Index(columns: ['status'], name: 'idx_orders_status')]
#[ORM\Index(columns: ['customer_id'], name: 'idx_orders_customer_id')]
#[ORM\UniqueConstraint(name: 'uq_orders_external_id', columns: ['external_id'])]
final class Order
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid', nullable: false)]
    private string $id;

    // String column: type, nullable, length must be specified
    #[ORM\Column(type: Types::STRING, length: 255, nullable: false)]
    private string $externalId;

    // Money: decimal (precision + scale required) — no float
    #[ORM\Column(type: Types::DECIMAL, precision: 15, scale: 2, nullable: false)]
    private string $amount;

    // Enum column: use enumType
    #[ORM\Column(type: Types::STRING, enumType: OrderStatus::class, nullable: false)]
    private OrderStatus $status = OrderStatus::Pending;

    // JSON: type: 'json' — no json_object
    #[ORM\Column(type: Types::JSON, nullable: false)]
    private array $metadata = [];

    // DateTime: DateTimeImmutable required — no new \DateTime()
    #[ORM\Column(type: Types::DATETIME_IMMUTABLE, nullable: false)]
    private DateTimeImmutable $createdAt;

    // FK relation: must declare an Index
    #[ORM\ManyToOne(targetEntity: Customer::class)]
    #[ORM\JoinColumn(name: 'customer_id', referencedColumnName: 'id', nullable: false)]
    private Customer $customer;
}
```

### 7.2 Repository Pattern

Handle all query logic in the Repository class. Direct queries in a controller or service are **prohibited**.

```php
final class OrderRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Order::class);
    }

    // No findAll() — always filter/paginate
    /**
     * @return Order[]
     */
    public function findByStatus(OrderStatus $status, int $limit = 50, int $offset = 0): array
    {
        return $this->createQueryBuilder('o')
            ->where('o.status = :status')
            ->setParameter('status', $status)
            ->orderBy('o.createdAt', 'DESC')
            ->setMaxResults($limit)
            ->setFirstResult($offset)
            ->getQuery()
            ->getResult();
    }

    // N+1 prevention: load associated entities in bulk with JOIN FETCH
    /**
     * @return Order[]
     */
    public function findWithItems(OrderStatus $status): array
    {
        return $this->createQueryBuilder('o')
            ->addSelect('i')                         // JOIN FETCH
            ->leftJoin('o.items', 'i')
            ->where('o.status = :status')
            ->setParameter('status', $status)
            ->getQuery()
            ->getResult();
    }
}
```

### 7.3 Migration Workflow

```bash
# After changing an entity
cd app && php bin/console make:migration

# Apply after review (run separately per EntityManager)
cd app && php bin/console doctrine:migrations:migrate --no-interaction --em=default --env=prod
```

Rules:

- Do not modify a migration file directly
- Review the SQL with `--dry-run` before production deployment
- Run separately for each EntityManager (`--em=<name>`)

---

## 8. Messenger / CQRS Pattern

### 8.1 Message Types and Roles

| Type | Directory | Role |
| --- | --- | --- |
| `MessageCommand` | `src/Domain/*/MessageCommand/` | Convey write intent (state change) |
| `MessageCommandHandler` | `src/Domain/*/MessageCommandHandler/` | Handle a Command (DB write) |
| `MessageQuery` | `src/Domain/*/MessageQuery/` | Convey read intent (query) |
| `MessageQueryHandler` | `src/Domain/*/MessageQueryHandler/` | Handle a Query (DB read) |
| `MessageEvent` | `src/Domain/*/MessageEvent/` | Notify a side effect (a fact that occurred) |
| `MessageEventHandler` | `src/Domain/*/MessageEventHandler/` | Handle an Event (email, notification, etc.) |

### 8.2 Defining a MessageCommand

```php
// src/Domain/Order/MessageCommand/CreateOrderCommand.php
namespace App\Domain\Order\MessageCommand;

use Symfony\Component\Messenger\Attribute\AsMessage;

#[AsMessage('async')]    // specify the async transport
readonly class CreateOrderCommand
{
    public function __construct(
        public string $customerId,
        public string $productId,
        public int    $quantity,
    ) {}
}
```

Do not put an Entity directly in a message. Pass only the ID and fetch it via the Repository in the handler.

### 8.3 Defining a MessageCommandHandler

```php
// src/Domain/Order/MessageCommandHandler/CreateOrderHandler.php
namespace App\Domain\Order\MessageCommandHandler;

use App\Domain\Order\MessageCommand\CreateOrderCommand;
use Symfony\Component\Messenger\Attribute\AsMessageHandler;

#[AsMessageHandler]
final class CreateOrderHandler
{
    public function __construct(
        private readonly OrderRepository    $orderRepository,
        private readonly MessageBusInterface $eventBus,
        #[Target('monolog.logger.order')]
        private readonly LoggerInterface    $logger,
    ) {}

    public function __invoke(CreateOrderCommand $command): void
    {
        $order = Order::create(
            customerId: $command->customerId,
            productId:  $command->productId,
            quantity:   $command->quantity,
        );

        $this->orderRepository->save($order, flush: true);

        // Separate side effects into an Event
        $this->eventBus->dispatch(new OrderCreatedEvent($order->getId()));

        $this->logger->info('Order created', ['order_id' => $order->getId()]);
    }
}
```

### 8.4 Retry Strategy and Failure Transport

```yaml
# config/packages/messenger.yaml
framework:
    messenger:
        failure_transport: failed

        transports:
            async:
                dsn: '%env(MESSENGER_TRANSPORT_DSN)%'
                retry_strategy:
                    max_retries: 3
                    delay: 1000       # ms
                    multiplier: 2     # 1s → 2s → 4s
                    max_delay: 10000
            failed:
                dsn: 'doctrine://default?queue_name=failed'
```

Handling unrecoverable errors:

```php
use Symfony\Component\Messenger\Exception\UnrecoverableMessageHandlingException;

public function __invoke(CreateOrderCommand $command): void
{
    $customer = $this->customerRepository->find($command->customerId);
    if (null === $customer) {
        // Same result on retry → throw UnrecoverableMessageHandlingException
        throw new UnrecoverableMessageHandlingException(
            "Customer not found: {$command->customerId}"
        );
    }
}
```

### 8.5 CQRS Boundary Rules

- Write operations must be dispatched as a `MessageCommand` (no direct writes in a Controller)
- Read operations use a `MessageQuery` or a direct Repository call
- Extract side effects (email, notification) inside a `MessageCommandHandler` into a `MessageEvent`
- Directly instantiating a handler class or calling its method is **prohibited** — always go through `MessageBusInterface`

---

## 9. Security

### 9.1 Input Validation — DTO + Validator

All input goes through a Form type or a DTO with `#[Assert\*]` constraints.
Direct access to `$request->get()`, `$_POST`, `$_GET` is **prohibited**.

```php
// src/Domain/Order/Dto/CreateOrderDto.php
use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Component\Security\Core\Validator\Constraints as SecurityAssert;

readonly class CreateOrderDto
{
    public function __construct(
        #[Assert\NotBlank]
        #[Assert\Uuid]
        public string $customerId,

        #[Assert\NotBlank]
        #[Assert\Uuid]
        public string $productId,

        #[Assert\Positive]
        #[Assert\LessThanOrEqual(value: 1000)]
        public int $quantity,

        #[Assert\NotBlank]
        #[Assert\Email]
        public string $email,

        #[SecurityAssert\UserPassword]
        #[Sensitive]       // masked in logs/stack traces
        public string $currentPassword,
    ) {}
}
```

### 9.2 CSRF Protection

Apply to every state-changing HTML form action.

```php
use Symfony\Component\Security\Http\Attribute\IsCsrfTokenValid;

#[Route('/orders/{id}/approve', methods: ['POST'])]
#[IsCsrfTokenValid('approve_order', tokenKey: '_token')]
public function approve(Order $order): Response
{
    // ...
}
```

Twig form:

```twig
<form method="POST" action="{{ path('order_approve', {id: order.id}) }}">
    <input type="hidden" name="_token" value="{{ csrf_token('approve_order') }}">
    <button type="submit">Approve</button>
</form>
```

Token-based APIs (JWT) are exempt from CSRF — but `Origin`/`Referer` header validation is required.

### 9.3 XSS Prevention

Do **not** disable Twig auto-escaping. Use the `|raw` filter only on trusted, server-generated HTML.

```twig
{# Prohibited: |raw on user input #}
{{ comment.content|raw }}

{# Recommended: leverage auto-escaping #}
{{ comment.content }}

{# When trusted HTML is needed: |raw after DOMPurify sanitization #}
{{ purifiedHtml|raw }}
```

### 9.4 SQL Injection Prevention

Use `:param` binding in DQL/QueryBuilder. String interpolation is **prohibited**.

```php
// Prohibited
$this->createQuery("SELECT o FROM Order o WHERE o.status = '{$status}'");

// Recommended
$this->createQueryBuilder('o')
    ->where('o.status = :status')
    ->setParameter('status', $status);
```

### 9.5 Rate Limiting

Apply to public POST endpoints (login, registration, password reset).

```yaml
# security.yaml — login throttling
security:
    firewalls:
        main:
            login_throttling:
                max_attempts: 5
                interval: '15 minutes'
```

API endpoint:

```php
use Symfony\Component\RateLimiter\RateLimiterFactory;

final class AuthController extends AbstractController
{
    public function __construct(
        #[Autowire(service: 'limiter.api_anonymous')]
        private readonly RateLimiterFactory $limiter,
    ) {}

    #[Route('/api/register', methods: ['POST'])]
    public function register(Request $request): JsonResponse
    {
        $limiter = $this->limiter->create($request->getClientIp());
        if (!$limiter->consume()->isAccepted()) {
            return $this->json(['error' => 'Too many requests'], 429);
        }
        // ...
    }
}
```

### 9.6 Sensitive Data Protection

```php
// Apply #[Sensitive] to sensitive DTO properties
readonly class ChangePasswordDto
{
    public function __construct(
        #[Sensitive]
        public string $currentPassword,
        #[Sensitive]
        public string $newPassword,
    ) {}
}

// Do not include sensitive data in logs
$this->logger->info('Password changed', [
    'user_id' => $userId,
    // 'password' => $password,  // ← never
]);
```

---

## 10. Error Handling and Logging

### 10.1 Exception Handling Principles

```php
// Prohibited: empty catch block
try {
    $order = $this->repository->findOrFail($id);
} catch (\Exception $e) {
    // do nothing — prohibited
}

// Prohibited: too broad an exception type
} catch (\Exception $e) { }

// Recommended: specific exception type + logging + re-throw
} catch (OrderNotFoundException $e) {
    $this->logger->warning('Order not found', ['order_id' => $id, 'error' => $e->getMessage()]);
    throw $e;
} catch (DatabaseException $e) {
    $this->logger->error('Database error', ['order_id' => $id, 'error' => $e]);
    throw new RuntimeException('Order fetch failed', previous: $e);
}
```

### 10.2 Named Logger Channels

Using the global `logger` service is **prohibited**. Use a per-domain channel.

```php
// Prohibited
public function __construct(private readonly LoggerInterface $logger) {}

// Recommended
public function __construct(
    #[Target('monolog.logger.order')]
    private readonly LoggerInterface $logger,
) {}
```

Channel configuration (`config/packages/monolog.yaml`):

```yaml
monolog:
    channels: [order, payment, provider]
```

### 10.3 Structured Log Context

Use a context array instead of string interpolation.

```php
// Prohibited
$this->logger->error("Order {$orderId} failed for user {$userId}");

// Recommended
$this->logger->error('Order processing failed', [
    'order_id' => $orderId,
    'user_id'  => $userId,
    'error'    => $e->getMessage(),
]);
```

### 10.4 Debug Log Guard

Guard `info`/`debug` level logs with the `$this->isDebug` flag.

```php
public function __construct(
    #[Autowire('%kernel.debug%')]
    private readonly bool $debug,
) {}

public function process(Order $order): void
{
    if ($this->debug) {
        $this->logger->debug('Processing order', ['order' => $order->getId()]);
    }
    // ...
}
```

---

## 11. Domain Structure Rules

### 11.1 Layer Placement Rules

| Class type | Directory |
| --- | --- |
| Entity | `src/Domain/{Domain}/Entity/` |
| Repository | `src/Domain/{Domain}/Repository/` |
| MessageCommand | `src/Domain/{Domain}/MessageCommand/` |
| MessageCommandHandler | `src/Domain/{Domain}/MessageCommandHandler/` |
| MessageQuery | `src/Domain/{Domain}/MessageQuery/` |
| MessageQueryHandler | `src/Domain/{Domain}/MessageQueryHandler/` |
| MessageEvent | `src/Domain/{Domain}/MessageEvent/` |
| MessageEventHandler | `src/Domain/{Domain}/MessageEventHandler/` |
| Service | `src/Domain/{Domain}/Service/` |
| EventSubscriber | `src/Domain/{Domain}/EventSubscriber/` |
| Scheduler | `src/Scheduler/{Domain}/` |
| Controller | `src/Controller/{Api\|Web}/` |
| DTO / Form | `src/Domain/{Domain}/Dto/` |
| Serializer | `src/Serializer/` |

### 11.2 Domain Dependency Direction

```text
Controller → MessageBus → MessageCommandHandler → Repository → Entity
Controller → MessageBus → MessageQueryHandler  → Repository
MessageCommandHandler → MessageEventHandler (via EventBus)
```

Cross-domain dependency rules:

- A class in one domain (`Company`) must **not** import an entity from another domain (`Partners`) directly
- Cross-domain data sharing → use a shared Entity or a `MessageQuery` dispatch

### 11.3 Abstract Domain Rules

Classes in the `Abstract/` directory may only be interfaces or abstract classes.
Place `final` concrete implementations outside `Abstract/`.

---

## 12. Static Analysis and Code Quality Tools

```bash
# PHPStan (level 8)
cd app && vendor/bin/phpstan analyse

# PHP-CS-Fixer (Symfony ruleset)
cd app && vendor/bin/php-cs-fixer fix --dry-run   # preview
cd app && vendor/bin/php-cs-fixer fix              # auto-fix

# PHPUnit
cd app && vendor/bin/phpunit
cd app && vendor/bin/phpunit --testsuite Unit
cd app && vendor/bin/phpunit --testsuite Integration

# Security audit
cd app && composer audit
```

Test boundaries:

| Layer | Base class | I/O |
| --- | --- | --- |
| Unit | `TestCase` | None (mocked) |
| Integration | `KernelTestCase` | Real PostgreSQL + Redis |
| Functional | `WebTestCase` | HTTP layer |

Integration tests use a **real PostgreSQL instance**. DB mocking is **prohibited**.

---

## 13. Verification Checklist

The review checklist is derived from the rules (SoT), so it is not duplicated in this document. After
finishing an implementation, review each PHP file with the `/app:php-symfony-review {file}` command;
the judgment criteria have their single source of truth in
`.claude/rules/app/base/php-symfony/00-overview-rule.md` ~ `11-performance-rule.md`.
