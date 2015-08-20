package ParametricTests
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.events.FocusEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Spacer;
	import mx.events.FlexEvent;
	import mx.controls.Alert;
	
	import spark.components.ComboBox;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.events.IndexChangeEvent;
	
	public class TwoTTest extends ParametricBackbone
	{
		public function TwoTTest()
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
		private var sample1MeanLabel:Label;
		private var sample1MeanInput:TextInput;
		private var spacer1:Spacer;
		
		private var sample1SdLabel:Label;
		private var sample1SdInput:TextInput;
		private var spacer2:Spacer;
		
		private var sample1SizeLabel:Label;
		private var sample1SizeInput:TextInput;
		
		private var sample2MeanLabel:Label;
		private var sample2MeanInput:TextInput;
		
		
		private var sample2SdLabel:Label;
		private var sample2SdInput:TextInput;
		
		
		private var sample2SizeLabel:Label;
		private var sample2SizeInput:TextInput;
		
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
			replace1Input.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
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
			replace2Input.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
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
			{	replace1Input.text = "0";
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
			{	replace2Input.text = "0";
				varName = "Mean("+colnames[col2CB.selectedIndex]+")-Mean("+colnames[col1CB.selectedIndex]+")";
				column2SelectedFlag = true;
				csvPaneDoneButton.enabled = true;
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
				testFlag = "1";
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
			sample1MeanLabel = new Label();
			sample1MeanLabel.text = "Mean of First Sample:";
			SampleParams.addElement(sample1MeanLabel);
			
			sample1MeanInput = new TextInput();
			sample1MeanInput.prompt="Enter a Numeric Value";
			sample1MeanInput.restrict="0-9.";
			sample1MeanInput.percentWidth=70;
			sample1MeanInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			SampleParams.addElement(sample1MeanInput);
			
			spacer1 = new Spacer();
			spacer1.percentHeight = 5;
			SampleParams.addElement(spacer1);
			
			//Standard Deviation Input
			sample1SdLabel = new Label();
			sample1SdLabel.text = "Standard Deviation of First Sample:";
			SampleParams.addElement(sample1SdLabel);
			
			sample1SdInput = new TextInput();
			sample1SdInput.prompt="Enter a numeric value";
			sample1SdInput.restrict="0-9.";
			sample1SdInput.percentWidth=70;
			sample1SdInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			SampleParams.addElement(sample1SdInput);
			
			spacer2 = new Spacer();
			spacer2.percentHeight = 5;
			SampleParams.addElement(spacer2);
			
			//Sample size input
			sample1SizeLabel = new Label();
			sample1SizeLabel.text = "Size of the first Sample:";
			SampleParams.addElement(sample1SizeLabel);
			
			sample1SizeInput = new TextInput();
			sample1SizeInput.prompt="Enter an integer value";
			sample1SizeInput.restrict="0-9";
			sample1SizeInput.percentWidth=70;
			sample1SizeInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			SampleParams.addElement(sample1SizeInput);
			
			
			//Mean value Input
			sample2MeanLabel = new Label();
			sample2MeanLabel.text = "Mean of Second Sample:";
			SampleParams.addElement(sample2MeanLabel);
			
			sample2MeanInput = new TextInput();
			sample2MeanInput.prompt="Enter a Numeric Value";
			sample2MeanInput.restrict="0-9.";
			sample2MeanInput.percentWidth=70;
			sample2MeanInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			SampleParams.addElement(sample2MeanInput);
			
			
			//Standard Deviation Input
			sample2SdLabel = new Label();
			sample2SdLabel.text = "Standard Deviation of Second Sample:";
			SampleParams.addElement(sample2SdLabel);
			
			sample2SdInput = new TextInput();
			sample2SdInput.prompt="Enter a numeric value";
			sample2SdInput.restrict="0-9.";
			sample2SdInput.percentWidth=70;
			sample2SdInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			SampleParams.addElement(sample2SdInput);
			
			
			
			//Sample size input
			sample2SizeLabel = new Label();
			sample2SizeLabel.text = "Size of the Second Sample:";
			SampleParams.addElement(sample2SizeLabel);
			
			sample2SizeInput = new TextInput();
			sample2SizeInput.prompt="Enter an integer value";
			sample2SizeInput.restrict="0-9";
			sample2SizeInput.percentWidth=70;
			sample2SizeInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			SampleParams.addElement(sample2SizeInput);
			
			if(column1SelectedFlag&&column2SelectedFlag)
			{	sample1MeanInput.text = values[0];
				sample1SdInput.text = values[1];
				sample1SizeInput.text = values[2];
				sample2MeanInput.text = values[3];
				sample2SdInput.text = values[4];
				sample2SizeInput.text = values[5];
			}
			this.addEventListener("valuesAvailable",updatePanel1);
		}
		
		protected function updatePanel1(event:Event):void
		{
			if(column1SelectedFlag&&column2SelectedFlag)
			{
				sample1MeanInput.text = values[0];
				sample1SdInput.text = values[1];
				sample1SizeInput.text = values[2];
				sample2MeanInput.text = values[3];
				sample2SdInput.text = values[4];
				sample2SizeInput.text = values[5];
				
			}
			
		}
		
		private function checksOnPanel1():Boolean
		{
			var result:Boolean = true;
			if(sample1MeanInput.text =="")
			{
				//Show an error icon
				sample1MeanInput.errorString = "Enter a value";
				result = false;
			}
			if(sample1SdInput.text=="")
			{
				//Show an error icon
				sample1SdInput.errorString = "Enter a value";
				result = false;
			}
			if(sample1SizeInput.text=="")
			{
				//Show an error icon
				sample1SizeInput.errorString = "Enter a value";
				result = false;
			}
			var result:Boolean = true;
			if(sample2MeanInput.text =="")
			{
				//Show an error icon
				sample2MeanInput.errorString = "Enter a value";
				result = false;
			}
			if(sample2SdInput.text=="")
			{
				//Show an error icon
				sample2SdInput.errorString = "Enter a value";
				result = false;
			}
			if(sample2SizeInput.text=="")
			{
				//Show an error icon
				sample2SizeInput.errorString = "Enter a value";
				result = false;
			}
			
			return result;
		}
		
		override protected function panel1NextButton_clickHandler(event:MouseEvent):void
		{
			if(checksOnPanel1())
			{
				if(varName == null)
				{
					varName = "Mean(X)-Mean(Y)";
				}
				panel1Flag = true;
				sample1MeanInput.editable = false;
				sample1SdInput.editable = false;
				sample1SizeInput.editable = false;
				sample2MeanInput.editable = false;
				sample2SdInput.editable = false;
				sample2SizeInput.editable = false;
				super.panel1NextButton_clickHandler(event);
			}		
			
		}
		
		override protected function panel1EditButton_clickHandler(event:MouseEvent):void
		{
			panel1Flag = false;
			sample1MeanInput.editable = true;
			sample1SdInput.editable = true;
			sample1SizeInput.editable = true;
			sample2MeanInput.editable = true;
			sample2SdInput.editable = true;
			sample2SizeInput.editable = true;
			
			panel1EditButton.enabled = false;
			panel1DoneButton.enabled = true;
		}
		
		override protected function panel1DoneButton_clickHandler(event:MouseEvent):void
		{
			if(checksOnPanel1())
			{
				panel1Flag = true;
				sample1MeanInput.editable = false;
				sample1SdInput.editable = false;
				sample1SizeInput.editable = false;
				sample2MeanInput.editable = false;
				sample2SdInput.editable = false;
				sample2SizeInput.editable = false;
				
				panel1EditButton.enabled = true;
				panel1DoneButton.enabled = false;
			}
		}
		
		private function addToPanel2():void
		{
			popnMeanLabel.text="Difference in Population Means";
		}
		
		override protected function compute_clickHandler(event:MouseEvent):void
		{	
			if(!panel1Flag)
			{
			Alert.show("Please complete the editing in the Panel1\nAnd try again","Editing in progress!!");
			}
			
			if(!panel2Flag)
			{
				Alert.show("Please complete the editing in the Panel2\nAnd try again","Editing in progress!!");
			}
			
			if(!hypoFlag)
			{
				Alert.show("Please select the hypotheses from the given list","Hypotheses not selected!!");
			}
			if(panel1Flag&&panel2Flag&&hypoFlag)
			{
				rFile = File.applicationDirectory.resolvePath("working/t-test.R").nativePath;
				testFlag = "1";
				args = new Vector.<String>;
				args.push(rFile);
				args.push(testFlag);
				args.push(tails);
				args.push(popnMeanInput.text);
				args.push(sample1MeanInput.text);
				args.push(sample1SdInput.text);
				args.push(sample1SizeInput.text);
				args.push(sample2MeanInput.text);
				args.push(sample2SdInput.text);
				args.push(sample2SizeInput.text);
				
				super.compute_clickHandler(event);
			}
		}
	}
}