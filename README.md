<p align="center"><img src="https://avatars3.githubusercontent.com/u/45311177?s=200&v=4"></p>

<p align="center">

![Coding standards status](https://github.com/nuxed/event-dispatcher/workflows/coding%20standards/badge.svg?branch=develop)
![Coding standards status](https://github.com/nuxed/event-dispatcher/workflows/static%20analysis/badge.svg?branch=develop)
[![Total Downloads](https://poser.pugx.org/nuxed/event-dispatcher/d/total.svg)](https://packagist.org/packages/nuxed/event-dispatcher)
[![Latest Stable Version](https://poser.pugx.org/nuxed/event-dispatcher/v/stable.svg)](https://packagist.org/packages/nuxed/event-dispatcher)
[![License](https://poser.pugx.org/nuxed/event-dispatcher/license.svg)](https://packagist.org/packages/nuxed/event-dispatcher)

</p>

# Nuxed Event Dispatcher

The Event Dispatcher component provides tools that allow your application components to communicate with each other by dispatching events and listening to them asynchronously.

### Installation

This package can be installed with [Composer](https://getcomposer.org).

```console
$ composer require nuxed/event-dispatcher
```

### Example

```hack
use namespace Nuxed\EventDispatcher;
use namespace Nuxed\EventDispatcher\ListenerProvider;

<<__EntryPoint>>
async function main(): Awaitable<void> {
  $provider = new ListenerProvider\ReifiedListenerProvider();

  $provider->listen<SomeEvent>(new SomeEventListener());
  $provider->listen<SomeOtherEvent>(new SomeOtherEventListener());

  $dispatcher = new EventDispatcher\EventDispatcher($provider);

  // dispatch multiple event listeners concurrently
  concurrent {
    // returns the event that was passed, now modified by listeners.
    $someEvent = await $dispatcher->dispatch<SomeEvent>(new SomeEvent());
    $someOtherEvent = await $dispatcher->dispatch<SomeOtherEvent>(new SomeOtherEvent());
  }
}
```

---

### Security

For information on reporting security vulnerabilities in Nuxed, see [SECURITY.md](SECURITY.md).

---

### License

Nuxed is open-sourced software licensed under the MIT-licensed.
