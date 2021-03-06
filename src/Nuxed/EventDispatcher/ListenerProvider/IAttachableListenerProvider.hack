namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace Nuxed\Contract\EventDispatcher\{
  Event,
  EventListener,
  ListenerProvider,
};

/**
 * The `IAttachableListenerProvider` listener provider allows you to attach event listeners,
 * to the provider after construction.
 *
 * Event listeners returned by `getListener($event)`, will be in the same order they were added in.
 *
 * @see Nuxed\Contract\EventDispatcher\ListenerProvider\IListenerProvider::getListeners()
 */
interface IAttachableListenerProvider
  extends ListenerProvider\IListenerProvider {
  /**
   * Attach a listener to event of type T.
   */
  public function listen<<<__Enforceable>> reify T as Event\IEvent>(
    EventListener\IEventListener<T> $listener,
  ): void;
}
