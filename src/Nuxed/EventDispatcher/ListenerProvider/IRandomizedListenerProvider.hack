namespace Nuxed\EventDispatcher\ListenerProvider;

/**
 * The `IRandomizedListenerProvider` listener provider is similar `IAttachableListenerProvider`,
 * However, listeners returned by `getListeners($event)` will be in random order.
 *
 * @see Nuxed\EventDispatcher\ListenerProvider\IListenerProvider::getListeners()
 */
interface IRandomizedListenerProvider extends IAttachableListenerProvider {}
