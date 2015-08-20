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
	
	public class PairedTTest extends ParametricBackbone
	{
		public function PairedTTest()
		{
			super();
		}
		
		//The elements to be added
		
		//CSV Pane
		private var column1SelectLabel:Label;
		private var spacer3:Spacer;
		private var col1CB:ComboBox;
		
		private var replace1:Label;
		private var replace1Input:TextInput;
		
		private var column2SelectLabel:Label;
		private var col2CB:ComboBox;
		
		private var replace2:Label;
		private var replace2Input:TextInput;
		
		private var column1SelectedFlag:Boolean = false;
		private var column2SelectedFlag:Boolean = false;
		
		
		
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
			column1SelectLabel = new Label();
			column1SelectLabel.text = "Please select a column";
			columnSelectionPane.addElement(column1SelectLabel);
			
			col1CB = new ComboBox();
			this.addEventListener("colNamesAvailable",setDataProvider);
			col1CB.addEventListener(IndexChangeEvent.CHANGE,column1Selected);
			columnSelectionPane.addElement(col1CB);
			
			
			spacer3 = new Spacer();
			spacer3.percentHeight = 1;
			columnSelectionPane.addElement(spacer3);
			
			replace1 = new Label();
			replace1.text = "replace missing values by:";
			columnSelectionPane.addElement(replace1);
			
			
			replace1Input = new TextInput();
			replace1Input.prompt="Enter a Numeric Value";
			replace1Input.restrict="0-9.";
			replace1Input.percentWidth=70;
			columnSelectionPane.addElement(replace1Input);
			
			
			column2SelectLabel = new Label();
			column2SelectLabel.text = "Please select a column";
			columnSelectionPane.addElement(column2SelectLabel);
			
			
			col2CB = new ComboBox();
			this.addEventListener("colNamesAvailable",setDataProvider);
			col2CB.addEventListener(IndexChangeEvent.CHANGE,column2Selected);
			columnSelectionPane.addElement(col2CB);
			
			//how to ensure that a selected column does not appear in the dropdown menu again?
			
			replace2 = new Label();
			replace2.text = "replace missing values by:";
			columnSelectionPane.addElement(replace2);
			
			replace2Input = new TextInput();
			replace2Input.prompt="Enter a Numeric Value";
			replace2Input.restrict="0-9.";
			replace2Input.percentWidth=70;
			columnSelectionPane.addElement(replace2Input);
			
			
			
			
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
			col1CB.dataProvider = colnames;
			col2CB.dataProvider = colnames;
			
		}
		
		protected function column1Selected(event:IndexChangeEvent):void
		{
			if(col1CB.selectedIndex==-3)
			{
				col1CB.selectedIndex=-1;
			}
			else
			{
				varName = "Mean("+colnames[col1CB.selectedIndex]+")";
				column1SelectedFlag = true;
			}
		}
		
		protected function column2Selected(event:IndexChangeEvent):void
		{
			if(col2CB.selectedIndex==-3)
			{
				col2CB.selectedIndex=-1;
			}
			else
			{
				varName = "Mean("+colnames[col2CB.selectedIndex]+"-"+colnames[col1CB.selectedIndex]+")";
				column2SelectedFlag = true;
			}
		}
		
		
		
		override protected function csvPaneDoneButton_clickHandler(event:MouseEvent):void
		{
			if(column1SelectedFlag&&column2SelectedFlag)
			{
				if(replace1Input.text!=""&&replace2Input.text!="")
				{
					csvDoneFlag = true;
				}
				else
				{
					//Show an error icon
					if(replace1Input.text=="")
					{
						replace1Input.errorString="Enter a Value";
					}
					
					if(replace2Input.text=="")
					{
						replace2Input.errorString="Enter a Value";
					}
					
				}
			}
			
			if(csvDoneFlag)
			{
				rFile = File.applicationDirectory.resolvePath("working/getStats.R").nativePath;
				testFlag = "2";
				args = new Vector.<String>;
				args.push(rFile);
				args.push(testFlag);
				args.push(csvFile.nativePath);
				args.push(colnames[col1CB.selectedIndex]);
				args.push(replace1Input.text);
				args.push(colnames[col2CB.selectedIndex]);
				args.push(replace2Input.text);
				
				super.csvPaneDoneButton_clickHandler(event);
			}
			
		}
		
		private function addToPanel1Final():void
		{
			//Mean value Input
			sampleMeanLabel = new Label();
			sampleMeanLabel.text = "Mean of Sample Differences:";
			SampleParams.addElement(sampleMeanLabel);
			
			sampleMeanInput = new TextInput();
			sampleMeanInput.prompt="Enter a Numeric Value";
			sampleMeanInput.restrict="0-9.";
			sampleMeanInput.percentWidth=70;
			if(column1SelectedFlag&&column2SelectedFlag)
			{
				sampleMeanInput.text = values[0];
			}
			SampleParams.addElement(sampleMeanInput);
			
			spacer1 = new Spacer();
			spacer1.percentHeight = 5;
			SampleParams.addElement(spacer1);
			
			//Standard Deviation Input
			sampleSdLabel = new Label();
			sampleSdLabel.text = "Standard Deviation of Sample Differences:";
			SampleParams.addElement(sampleSdLabel);
			
			sampleSdInput = new TextInput();
			sampleSdInput.prompt="Enter a numeric value";
			sampleSdInput.restrict="0-9.";
			sampleSdInput.percentWidth=70;
			if(column1SelectedFlag&&column2SelectedFlag)
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
			sampleSizeInput.prompt="Enter an integer value";
			sampleSizeInput.restrict="0-9";
			sampleSizeInput.percentWidth=70;
			if(column1SelectedFlag&&column2SelectedFlag)
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
				
				sampleMeanInput.errorString="Enter a value";//Show an error icon
			}
			
			if(sampleSdInput.text!="")
			{
				var check2:Boolean = true;
			}
			else
			{
				check2 = false;
				sampleSdInput.errorString="Enter a value";
				//Show an error icon
			}
			
			if(sampleSizeInput.text!="")
			{
				var check3:Boolean = true;
			}
			else
			{
				check3 = false;
				sampleSizeInput.errorString="Enter a value";
				//Show an error icon
			}
			
			if(check1&&check2&&check3)
			{	
				if (varName == null)
				{
					varName = "Mean(X1-X2)"
				}
				panel1Flag = true;
				super.panel1NextButton_clickHandler(event);
			}
			
		}
		
		private function addToPanel2():void
		{
			popnMeanLabel.text="Mean of Population Differences";
		}
		
		override protected function compute_clickHandler(event:MouseEvent):void
		{
			if(panel1Flag&&panel2Flag&&hypoFlag)
			{
				rFile = File.applicationDirectory.resolvePath("working/t-test.R").nativePath;
				testFlag = "2";
				args = new Vector.<String>;
				args.push(rFile);
				args.push(testFlag);
				args.push(tails);
				args.push(popnMeanInput.text);
				args.push(sampleMeanInput.text);
				args.push(sampleSdInput.text);
				args.push(sampleSizeInput.text);
				
				super.compute_clickHandler(event);
			}
		}		
	}
}