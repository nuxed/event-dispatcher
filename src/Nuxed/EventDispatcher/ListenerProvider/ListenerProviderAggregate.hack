namespace Nuxed\EventDispatcher\ListenerProvider;

use namespace Nuxed\Contract\EventDispatcher\{
  Event,
  EventListener,
  ListenerProvider,
};

/**
 * The `ListenerProviderAggregate` allows you to combine multiple listener providers,
 * to use with the same event dispatcher.
 *
 * @see Nuxed\EventDispatcher\ListenerProviderAggregate::attach()
 */
final class ListenerProviderAggregate
  implements ListenerProvider\IListenerProvider {
  private vec<ListenerProvider\IListenerProvider> $providers = vec[];

  /**
   * {@inheritdoc}
   */
  public async function getListeners<<<__Enforceable>> reify T as Event\IEvent>(
    T $event,
  ): AsyncIterator<EventListener\IEventListener<T>> {
    foreach ($this->providers as $provider) {
      foreach ($provider->getListeners<T>($event) await as $listener) {
        yield $listener;
      }
    }
  }

  /**
   * Attach a listener provider to the listeners aggregate.
   */
  public function attach(ListenerProvider\IListenerProvider $provider): void {
    $this->providers[] = $provider;
  }
}
