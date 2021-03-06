package ParametricTests
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.controls.Spacer;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
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
				help2.text=stringCollection.secondScreenText.onesamplebuttontext.sampleText;
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
					addToSampleData();
				}
			}
			if(currentState == 'popnData')
			{	
				help2.text=stringCollection.secondScreenText.onesamplebuttontext.populationText;
				help2.text+="\n\n"+stringCollection.secondScreenText.commonText.significanceText;
				addToPopnData();
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
			replace1.text = "Replace missing values by";
			columnSelectionPane.addElement(replace1);
			
			replaceInput = new TextInput();
			replaceInput.prompt="Enter a Numeric Value";
			replaceInput.restrict="0-9.";
			replaceInput.percentWidth=70;
			replaceInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			columnSelectionPane.addElement(replaceInput);
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
				help2.text+="\n\n"+stringCollection.secondScreenText.commonText.missingvalText;
				replaceInput.text = "0";
				varName = "Mean("+colnames[colCB.selectedIndex]+")";
				columnSelectedFlag = true;
				csvPaneDoneButton.enabled = true;
			}
		}
		
		override protected function csvPaneDoneButton_clickHandler(event:MouseEvent):void
		{
			if(columnSelectedFlag)
			{
				if(StringUtil.trim(replaceInput.text)!="")
				{
					csvDoneFlag = true;
				}
				else
				{
					//Show an error icon
					replaceInput.errorString = "Enter a value";
				}
			}
			
			//write the structure of the R script
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
		
		private function addToSampleData():void
		{	
			help2.text=stringCollection.secondScreenText.commonText.entervalueText;
			
			//Mean value Input
			sampleMeanLabel = new Label();
			sampleMeanLabel.text = "Sample Mean";
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
			sampleSdLabel.text = "Sample Standard Deviation";
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
			sampleSizeInput.prompt="Enter a integer value";
			sampleSizeInput.restrict="0-9";
			sampleSizeInput.percentWidth=70;
			sampleSizeInput.addEventListener(FocusEvent.FOCUS_OUT,checkNumber);
			SampleParams.addElement(sampleSizeInput);
			
			//For adding the values for the first time user transitions from loadCSV to state1Final
			if(columnSelectedFlag)
			{
				sampleMeanInput.text = values[0];
				sampleSdInput.text = values[1];
				sampleSizeInput.text = values[2];
			}
			
			//For changes during going back to CSV and back
			this.addEventListener("valuesAvailable",updateSampleData);
		}
		
		protected function updateSampleData(event:Event):void
		{
			if(columnSelectedFlag)
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
					varName = "Mean(X)";
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
			
		}
		
		override protected function compute_clickHandler(event:MouseEvent):void
		{
			if(!sampleDataFlag)
			{
				Alert.show("Please complete the editing in the Sample Data\nAnd try again","Editing in progress!!");
			}
			
			if(!popnDataFlag)
			{
				Alert.show("Please complete the editing in the Population Data\nAnd try again","Editing in progress!!");
			}
			
			if(!hypoFlag)
			{
				Alert.show("Please select the hypotheses from the given list","Hypotheses not selected!!");
			}
			
			if(sampleDataFlag&&popnDataFlag&&hypoFlag)
			{
				rFile = File.applicationDirectory.resolvePath("working/t-test.R").nativePath;
				testFlag = "0";
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