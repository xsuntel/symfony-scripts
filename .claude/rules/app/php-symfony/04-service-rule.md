---
paths:
  - "app/src/Service/**/*.php"
---

# Service / Dependency Injection Rules

@see https://symfony.com/doc/current/service_container.html

## Autowiring

All services use autowiring by default. Dependencies are resolved automatically via constructor type hints.

- Keep `autowire: true` and `autoconfigure: true` in `config/services.yaml` — never remove them.
- Autoconfiguration automatically tags `EventSubscriber`, `Twig\Extension`, `Command`, etc.

```yaml
# config/services.yaml — keep these defaults
services:
    _defaults:
        autowire: true
        autoconfigure: true
```

## Service Visibility

- All services are **private** by default — this is correct and intended.
- Mark a service `public` only when it must be fetched directly from the container at runtime (rare: test setup, legacy code).

## Constructor Injection Only

Never use setter injection, property injection, or `ContainerAware`. Use only constructor injection.

```php
final class InvoiceService
{
    public function __construct(
        private readonly InvoiceRepository $invoiceRepository,
        private readonly MailerInterface $mailer,
        #[Autowire(param: 'app.invoice_due_days')]
        private readonly int $dueDays,
    ) {}
}
```

## Interface Binding

When a class depends on an interface, bind the concrete implementation in `config/services.yaml`:

```yaml
services:
    App\Service\PaymentGatewayInterface: '@App\Service\StripeGateway'
```

Or use an explicit alias:

```yaml
services:
    App\Service\StripeGateway: ~

    App\Service\PaymentGatewayInterface:
        alias: App\Service\StripeGateway
```

When multiple implementations exist, specify the concrete class explicitly with `bind` or `alias`.
Controllers and services should type-hint the interface — do not depend directly on a concrete implementation.

```yaml
# config/services.yaml
services:
    App\Service\PaymentInterface: '@App\Service\StripePayment'

    _defaults:
        bind:
            $mailer: '@App\Mailer\CustomMailer'
```

## Named Services and Attributes

For services that cannot be autowired, use Symfony Attributes instead of manual YAML wiring:

```php
#[Autowire(service: 'monolog.logger.payment')]
private readonly LoggerInterface $logger,

#[Autowire(param: 'kernel.debug')]
private readonly bool $isDebug,

#[Target('paymentLogger')]
private readonly LoggerInterface $logger,
```

## Service Naming

- Service IDs are the FQCN by default — never define short custom IDs.
- Define a custom ID only for third-party classes or services created by a factory.

@see https://symfony.com/doc/current/service_container/autowiring.html

## Debugging Commands

```bash
# List all autowireable service types
php bin/console debug:autowiring

# Filter by keyword
php bin/console debug:autowiring logger

# List all container services
php bin/console debug:container

# Inspect a specific service
php bin/console debug:container App\Service\MyService
```

## Lazy Services

Defer service initialization until the first method call. Apply to services with expensive initialization logic.

```php
use Symfony\Component\DependencyInjection\Attribute\Lazy;

class HeavyService
{
    public function __construct(
        #[Lazy] private readonly SomeHeavyDependency $dependency
    ) {}
}
```

@see https://symfony.com/doc/current/service_container/lazy_services.html
