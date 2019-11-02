namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace Nuxed\EventDispatcher\{Event, EventListener};

/**
 * The `IAttachableListenerProvider` listener provider allows you to attach event listeners,
 * to the provider after construction.
 *
 * Event listeners returned by `getListener($event)`, will be in the same order they were added in.
 *
 * @see Nuxed\EventDispatcher\ListenerProvider\IListenerProvider::getListeners()
 */
interface IAttachableListenerProvider extends IListenerProvider {
  /**
   * Attach a listener to the given event.
   */
  public function listen<T as Event\IEvent>(
    classname<T> $event,
    EventListener\IEventListener<T> $listener,
  ): void;
}
