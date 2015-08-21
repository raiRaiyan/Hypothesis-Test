package ParametricTests
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Alert;
	import mx.controls.Spacer;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
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
		
		
		
		//sampleDataFinal
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
			if(currentState =='landingPage')
			{	
				help2.text=stringCollection.secondScreenText.pairedbuttontext.sampleText;
			}
			
			if(currentState == 'loadCSV')
			{ 	
				help2.text=stringCollection.secondScreenText.commonText.filepathText;
				if(!backToCSVFlag)
				{
					addToCSVPane();
				}
			}
			if(currentState == 'sampleData')
			{	
				if(!backToCSVFlag)
				{
					addToSampleDataFinal();
				}
			}
			if(currentState == 'popnData')
			{	
				help2.text=stringCollection.secondScreenText.pairedbuttontext.populationText;
				addToPopnData();
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
			replace1.text = "Replace missing values by";
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
			
			
			
			replace2 = new Label();
			replace2.text = "Replace missing values by";
			columnSelectionPane.addElement(replace2);
			
			replace2Input = new TextInput();
			replace2Input.prompt="Enter a Numeric Value";
			replace2Input.restrict="0-9.";
			replace2Input.percentWidth=70;
			replace2Input.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			columnSelectionPane.addElement(replace2Input);
			
			
			
			
		}

		protected function switchState(event:Event):void
		{
		currentState = 'state1Final';
		
		}
		
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
				help2.text+="\n"+stringCollection.secondScreenText.commonText.missingvalText;
				replace1Input.text = "0";
				varName = "Mean("+colnames[col1CB.selectedIndex]+")";
				column1SelectedFlag = true;
				csvPaneDoneButton.enabled = true;
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
				help2.text+="\n"+stringCollection.secondScreenText.commonText.missingvalText;
				replace2Input.text = "0";
				varName = "Mean("+colnames[col2CB.selectedIndex]+"-"+colnames[col1CB.selectedIndex]+")";
				column2SelectedFlag = true;
				csvPaneDoneButton.enabled = true;
			}
		}
		
		
		
		override protected function csvPaneDoneButton_clickHandler(event:MouseEvent):void
		{
			if(column1SelectedFlag&&column2SelectedFlag)
			{
				if(StringUtil.trim(replace1Input.text)!=""&&StringUtil.trim(replace2Input.text)!="")
				{
					csvDoneFlag = true;
				}
				else
				{
					//Show an error icon
					if(StringUtil.trim(replace1Input.text)=="")
					{
						replace1Input.errorString="Enter a Value";
					}
					
					if(StringUtil.trim(replace2Input.text)=="")
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
		
		private function addToSampleDataFinal():void
		{	
			help2.text=stringCollection.secondScreenText.commonText.entervalueText;
			
			//Mean value Input
			sampleMeanLabel = new Label();
			sampleMeanLabel.text = "Mean of Sample Differences";
			SampleParams.addElement(sampleMeanLabel);
			
			sampleMeanInput = new TextInput();
			sampleMeanInput.prompt="Enter a Numeric Value";
			sampleMeanInput.restrict="0-9.";
			sampleMeanInput.percentWidth=70;
			sampleMeanInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			SampleParams.addElement(sampleMeanInput);
			
			spacer1 = new Spacer();
			spacer1.percentHeight = 5;
			SampleParams.addElement(spacer1);
			
			//Standard Deviation Input
			sampleSdLabel = new Label();
			sampleSdLabel.text = "Standard Deviation of Sample Differences";
			SampleParams.addElement(sampleSdLabel);
			
			sampleSdInput = new TextInput();
			sampleSdInput.prompt="Enter a numeric value";
			sampleSdInput.restrict="0-9.";
			sampleSdInput.percentWidth=70;
			sampleSdInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			SampleParams.addElement(sampleSdInput);
			
			spacer2 = new Spacer();
			spacer2.percentHeight = 5;
			SampleParams.addElement(spacer2);
			
			//Sample size input
			sampleSizeLabel = new Label();
			sampleSizeLabel.text = "Sample Size";
			SampleParams.addElement(sampleSizeLabel);
			
			sampleSizeInput = new TextInput();
			sampleSizeInput.prompt="Enter an integer value";
			sampleSizeInput.restrict="0-9";
			sampleSizeInput.percentWidth=70;
			sampleSizeInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			SampleParams.addElement(sampleSizeInput);
			if(column1SelectedFlag&&column2SelectedFlag)
			{
				sampleMeanInput.text = values[0];
				sampleSdInput.text = values[1];
				sampleSizeInput.text = values[2];
			}
			this.addEventListener("valuesAvailable",updatesampleData);
			
		}
		
		protected function updatesampleData(event:Event):void
		{
			if(column1SelectedFlag&&column2SelectedFlag)
			{
				sampleMeanInput.text = values[0];
				sampleSdInput.text = values[1];
				sampleSizeInput.text = values[2];
			}
			
		}
		
		private function checksOnSampleData():Boolean
		{
			var result:Boolean = true;
			if(StringUtil.trim(sampleMeanInput.text) =="")
			{
				//Show an error icon
				sampleMeanInput.errorString = "Enter a value";
				result = false;
			}
			if(StringUtil.trim(sampleSdInput.text)=="")
			{
				//Show an error icon
				sampleSdInput.errorString = "Enter a value";
				result = false;
			}
			if(StringUtil.trim(sampleSizeInput.text)=="")
			{
				//Show an error icon
				sampleSizeInput.errorString = "Enter a value";
				result = false;
			}
			return result;
		}
		
		override protected function sampleDataNextButton_clickHandler(event:MouseEvent):void
		{
			if(checksOnSampleData())
			{
				if(varName == null)
				{
					varName = "Mean(X-Y)";
				}
				sampleDataFlag = true;
				sampleMeanInput.editable = false;
				sampleSdInput.editable = false;
				sampleSizeInput.editable = false;
				super.sampleDataNextButton_clickHandler(event);
			}			
		}
		
		override protected function sampleDataEditButton_clickHandler(event:MouseEvent):void
		{
			sampleDataFlag = false;
			sampleMeanInput.editable = true;
			sampleSdInput.editable = true;
			sampleSizeInput.editable = true;
			
			sampleDataEditButton.enabled = false;
			sampleDataDoneButton.enabled = true;
		}
		
		override protected function sampleDataDoneButton_clickHandler(event:MouseEvent):void
		{
			if(checksOnSampleData())
			{
				sampleDataFlag = true;
				sampleMeanInput.editable = false;
				sampleSdInput.editable = false;
				sampleSizeInput.editable = false;
				
				sampleDataEditButton.enabled = true;
				sampleDataDoneButton.enabled = false;
			}
		}
		
		private function addToPopnData():void
		{
			popnMeanLabel.text="Mean of Population Differences";
		}
		
		override protected function compute_clickHandler(event:MouseEvent):void
		{
			if(!sampleDataFlag)
			{
				Alert.show("Please complete the editing in the sampleData\nAnd try again","Editing in progress!!");
			}
			
			if(!popnDataFlag)
			{
				Alert.show("Please complete the editing in the popnData\nAnd try again","Editing in progress!!");
			}
			
			if(!hypoFlag)
			{
				Alert.show("Please select the hypotheses from the given list","Hypotheses not selected!!");
			}
			if(sampleDataFlag&&popnDataFlag&&hypoFlag)
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