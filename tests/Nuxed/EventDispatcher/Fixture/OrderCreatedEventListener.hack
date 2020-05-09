namespace Nuxed\Test\EventDispatcher\Fixture;

use namespace Nuxed\Contract\EventDispatcher\EventListener;

class OrderCreatedEventListener
  implements EventListener\IEventListener<OrderCreatedEvent> {
  public async function process(OrderCreatedEvent $event): Awaitable<void> {
    throw new \Exception("Error Processing Event");
  }
}
