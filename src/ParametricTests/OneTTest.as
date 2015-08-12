package ParametricTests
{
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Spacer;
	import mx.events.FlexEvent;
	
	import spark.components.ComboBox;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.events.IndexChangeEvent;

	public class OneTTest extends ParametricBackbone
	{
		public function OneTTest()
		{
			super();
		}
		
		//The elements to be added
		
		//CSV Pane
		private var colCB:ComboBox;
		
		//Panel1Final
		private var sampleMeanLabel:Label;
		private var sampleMeanInput:TextInput;
		private var spacer1:Spacer;
		
		private var sampleSdLabel:Label;
		private var sampleSdInput:TextInput;
		private var spacer2:Spacer;
		
		private var sampleSizeLabel:Label;
		private var sampleSizeInput:TextInput;
		
		override protected function backbone_stateChangeCompleteHandler(event:FlexEvent):void
		{
			if(currentState == 'state1Final')
			{
				addToPanel1Final();
			}
			if(currentState == 'state2')
			{
				addToPanel2();
			}
			if(currentState == 'loadCSV')
			{
				addToCSVPane();
			}
		}
		
		private function addToPanel1Final():void
		{
			//Mean value Input
			sampleMeanLabel = new Label();
			sampleMeanLabel.text = "Sample Mean:";
			SampleParams.addElement(sampleMeanLabel);
			
			sampleMeanInput = new TextInput();
			sampleMeanInput.prompt="Enter a Numeric Value";
			sampleMeanInput.restrict="0-9.";
			sampleMeanInput.percentWidth=70;
			SampleParams.addElement(sampleMeanInput);
			
			spacer1 = new Spacer();
			spacer1.percentHeight = 5;
			SampleParams.addElement(spacer1);
			
			//Standard Deviation Input
			sampleSdLabel = new Label();
			sampleSdLabel.text = "Sample Standard Deviation:";
			SampleParams.addElement(sampleSdLabel);
			
			sampleSdInput = new TextInput();
			sampleSdInput.prompt="Enter a numeric value";
			sampleSdInput.restrict="0-9.";
			sampleSdInput.percentWidth=70;
			SampleParams.addElement(sampleSdInput);
			
			spacer2 = new Spacer();
			spacer2.percentHeight = 5;
			SampleParams.addElement(spacer2);
			
			//Sample size input
			sampleSizeLabel = new Label();
			sampleSizeLabel.text = "Sample Size:";
			SampleParams.addElement(sampleSizeLabel);
			
			sampleSizeInput = new TextInput();
			sampleSizeInput.prompt="Enter a integer value";
			sampleSizeInput.restrict="0-9";
			sampleSizeInput.percentWidth=70;
			SampleParams.addElement(sampleSizeInput);
		}
		
		private function addToPanel2():void
		{
			
		}
		
		private function addToCSVPane():void
		{
			//Column selection combo box
			colCB = new ComboBox();
			
			//Data binding not working
			//colCB.dataProvider = colnames;
			
			this.addEventListener("colNamesAvailable",setDataProvider);
			
			colCB.addEventListener(IndexChangeEvent.CHANGE,columnSelected);
			
			columnSelectionPane.addElement(colCB);
		}
		
		protected function setDataProvider(event:Event):void
		{
			colCB.dataProvider = colnames;
		}
		
		protected function columnSelected(event:IndexChangeEvent):void
		{
			if(colCB.selectedIndex==-3)
			{
				colCB.selectedIndex=-1;
			}
			else
			{
				varName = colnames[colCB.selectedIndex];
			}
		}
		
	}
}