package ParametricTests
{
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;

	public class PairedTTest extends ParametricBackbone
	{
		public function PairedTTest()
		{
			super();
		}
		
		override protected function backboneCreationCompleteHandler(event:FlexEvent):void
		{
			//var b:Button = new Button();
			//panel1.addElement(b);
		}
		
		/* Checking overriding methods - Working
		override protected function panel1NextButton_clickHandler(event:MouseEvent):void
		{
			super.panel1NextButton_clickHandler(event);
		}
		*/
	}
}