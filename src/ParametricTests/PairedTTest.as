package ParametricTests
{
	import mx.events.FlexEvent;
	
	import spark.components.Button;

	public class PairedTTest extends ParametricBackbone
	{
		public function PairedTTest()
		{
			super();
		}
		
		override protected function group1_creationCompleteHandler(event:FlexEvent):void
		{
			var b:Button = new Button();
			panel1.addElement(b);
		}
	}
}