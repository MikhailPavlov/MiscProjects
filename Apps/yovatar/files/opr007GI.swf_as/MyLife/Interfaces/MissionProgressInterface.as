package MyLife.Interfaces 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class MissionProgressInterface extends MyLife.Interfaces.TweenButtonDialog
    {
        public function MissionProgressInterface()
        {
            super();
            x = 15;
            y = 95;
            btnDance.visible = false;
            btnFight.visible = false;
            btnKiss.visible = false;
            btnJoke.visible = false;
            btnGift.visible = false;
            btnMessage.visible = false;
            addButtonListeners(btnDance);
            addButtonListeners(btnFight);
            addButtonListeners(btnKiss);
            addButtonListeners(btnJoke);
            addButtonListeners(btnGift);
            addButtonListeners(btnMessage);
            btnClose.addEventListener(MouseEvent.CLICK, btnCloseHandler);
            return;
        }

        private function btnCloseHandler(arg1:flash.events.MouseEvent):void
        {
            btnClose.removeEventListener(MouseEvent.CLICK, btnCloseHandler);
            removeButtonListeners(btnDance);
            removeButtonListeners(btnFight);
            removeButtonListeners(btnKiss);
            removeButtonListeners(btnJoke);
            removeButtonListeners(btnGift);
            removeButtonListeners(btnMessage);
            dispatchEvent(new Event(Event.CLOSE));
            return;
        }

        public var message:flash.text.TextField;

        public var btnMessage:flash.display.SimpleButton;

        public var btnGift:flash.display.SimpleButton;

        public var title:flash.text.TextField;

        public var btnFight:flash.display.SimpleButton;

        public var btnDance:flash.display.SimpleButton;

        public var btnKiss:flash.display.SimpleButton;

        public var btnJoke:flash.display.SimpleButton;

        public var btnClose:flash.display.SimpleButton;
    }
}
