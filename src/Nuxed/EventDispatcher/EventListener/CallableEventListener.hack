namespace Nuxed\EventDispatcher\EventListener;

use namespace Nuxed\EventDispatcher\Event;

/**
 * Decorator defines a callable listener for an event.
 */
final class CallableEventListener<T as Event\IEvent>
  implements IEventListener<T> {
  public function __construct(
    private (function(T): Awaitable<void>) $listener,
  ) {}

  /**
   * {@inheritdoc}
   */
  public function process(T $event): Awaitable<void> {
    return ($this->listener)($event);
  }
}
