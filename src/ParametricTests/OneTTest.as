package ParametricTests
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
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
		private var columnSelectLabel:Label;
		private var spacer3:Spacer;
		private var colCB:ComboBox;
		
		private var replace1:Label;
		private var replaceInput:TextInput;
		
		private var columnSelectedFlag:Boolean = false;
		
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
			if(currentState == 'loadCSV')
			{
				addToCSVPane();
			}
			if(currentState == 'state1Final')
			{
				addToPanel1Final();
			}
			if(currentState == 'state2')
			{
				addToPanel2();
			}
			super.backbone_stateChangeCompleteHandler(event);
		}
		
		private function addToCSVPane():void
		{
			//Column selection combo box
			columnSelectLabel = new Label();
			columnSelectLabel.text = "Please select a column";
			columnSelectionPane.addElement(columnSelectLabel);

			colCB = new ComboBox();
			this.addEventListener("colNamesAvailable",setDataProvider);
			colCB.addEventListener(IndexChangeEvent.CHANGE,columnSelected);
			columnSelectionPane.addElement(colCB);
			
			spacer3 = new Spacer();
			spacer3.percentHeight = 1;
			columnSelectionPane.addElement(spacer3);
			
			replace1 = new Label();
			replace1.text = "replace missing values by:";
			columnSelectionPane.addElement(replace1);
			
			replaceInput = new TextInput();
			replaceInput.prompt="Enter a Numeric Value";
			replaceInput.restrict="0-9.";
			replaceInput.percentWidth=70;
			columnSelectionPane.addElement(replaceInput);
			
			//Obselete 1
			//this.addEventListener("valuesAvailable",switchState);
		}
		/* Obselete
		protected function switchState(event:Event):void
		{
		currentState = 'state1Final';
		
		}
		*/
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
				varName = "Mean("+colnames[colCB.selectedIndex]+")";
				columnSelectedFlag = true;
			}
		}
		
		override protected function csvPaneDoneButton_clickHandler(event:MouseEvent):void
		{
			if(columnSelectedFlag)
			{
				if(replaceInput.text!="")
				{
					csvDoneFlag = true;
				}
				else
				{
					//Show an error icon
				}
			}
			
			if(csvDoneFlag)
			{
				rFile = File.applicationDirectory.resolvePath("working/getStats.R").nativePath;
				testFlag = "0";
				args = new Vector.<String>;
				args.push(rFile);
				args.push(testFlag);
				args.push(csvFile.nativePath);
				args.push(colnames[colCB.selectedIndex]);
				args.push(replaceInput.text);
				
				super.csvPaneDoneButton_clickHandler(event);
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
			if(columnSelectedFlag)
			{
				sampleMeanInput.text = values[0];
			}
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
			if(columnSelectedFlag)
			{
				sampleSdInput.text = values[1];
			}
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
			if(columnSelectedFlag)
			{
				sampleSizeInput.text = values[2];
			}
			SampleParams.addElement(sampleSizeInput);
		}
		
		override protected function panel1NextButton_clickHandler(event:MouseEvent):void
		{
			if(sampleMeanInput.text!="")
			{
				var check1:Boolean = true;
			}
			else
			{
				check1 = false;
				//Show an error icon
			}
			
			if(sampleSdInput.text!="")
			{
				var check2:Boolean = true;
			}
			else
			{
				check2 = false;
				//Show an error icon
			}
			
			if(sampleSizeInput.text!="")
			{
				var check3:Boolean = true;
			}
			else
			{
				check3 = false;
				//Show an error icon
			}
			
			if(check1&&check2&&check3)
			{
				panel1Flag = true;
				super.panel1NextButton_clickHandler(event);
			}
			
		}
		
		private function addToPanel2():void
		{
			
		}
		
		
	}
}