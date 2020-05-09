namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace Nuxed\Contract\EventDispatcher\{
  Event,
  EventListener,
  ListenerProvider,
};

/**
 * The `IReifiedListenerProvider` uses reified generics features to determine the event type,
 * instead of recieving it as an argument.
 *
 * @see Nuxed\Contract\EventDispatcher\ListenerProvider\IListenerProvider::getListeners()
 */
interface IReifiedListenerProvider extends ListenerProvider\IListenerProvider {
  /**
   * Attach a listener
   */
  public function listen<<<__Enforceable>> reify T as Event\IEvent>(
    EventListener\IEventListener<T> $listener,
  ): void;
}
