namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace Nuxed\Contract\EventDispatcher\{Event, EventListener};

/**
 * The `IPrioritizedListenerProvider` listener provider allows you to attach event listeners,
 * to the provider after construction, with a given priority.
 *
 * Event listeners returned by `getListener($event)`, will be in the ordered by priority.
 *
 * @see Nuxed\Contract\EventDispatcher\ListenerProvider\IListenerProvider::getListeners()
 */
interface IPrioritizedListenerProvider extends IAttachableListenerProvider {
  /**
   * Attach a listener with optional priority
   */
  public function listen<T as Event\IEvent>(
    classname<T> $event,
    EventListener\IEventListener<T> $listener,
    int $priority = 1,
  ): void;
}
