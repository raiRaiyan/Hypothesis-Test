package NonParametricTests
{
	import mx.events.FlexEvent;

	public class IndependenceCTest extends NonParametricBackbone
	{
		public function IndependenceCTest()
		{
			super();
		}
		override protected function backboneStateChangeCompleteHandler(event:FlexEvent):void
		{
			//Add the help text for the processflow
			
			//Add the title to the first panel
			csvPanel.title = "The Data for the Hypothesis";
		}
		
		
	}
}