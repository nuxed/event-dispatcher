namespace Nuxed\EventDispatcher\Event;

use namespace HH\ReifiedGenerics;
use namespace Nuxed\EventDispatcher\EventListener;

final class ErrorEvent<<<__Enforceable>> reify T as IEvent>
  extends \Exception
  implements IEvent {
  public function __construct(
    private T $event,
    private EventListener\IEventListener<T> $listener,
    private \Exception $e,
  ) {
    parent::__construct($e->getMessage(), $e->getCode(), $e);
  }

  public function getEventType(): classname<T> {
    return ReifiedGenerics\get_classname<T>();
  }

  public function getEvent(): T {
    return $this->event;
  }

  public function getListener(): EventListener\IEventListener<T> {
    return $this->listener;
  }

  public function getException(): \Exception {
    return $this->e;
  }
}
