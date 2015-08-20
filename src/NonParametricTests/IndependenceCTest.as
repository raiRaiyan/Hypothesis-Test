package NonParametricTests
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.controls.Alert;
	import mx.controls.Spacer;
	import mx.events.FlexEvent;
	
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.gridClasses.GridColumn;
	import spark.events.IndexChangeEvent;

	public class IndependenceCTest extends NonParametricBackbone
	{
		private var comboBox1:ComboBox;
		private var comboBox2:ComboBox;
		private var significanceValue:String;
		private var contingencyTableCheck:CheckBox;
		private var selectColumnLabel1:Label;
		private var selectColumnLabel2:Label;
		private var missingValueInput1:TextInput;
		private var missingValueInput2:TextInput;
		
		public function IndependenceCTest()
		{
			super();
		}
		override protected function backboneStateChangeCompleteHandler(event:FlexEvent):void
		{
			//Add the help text for the processflow
			
			//Add the title to the first panel
			csvPanel.title = "The Data for the Hypothesis";
			if(currentState == 'state1'){
				displayString.visible = true;
				panelHelpText.text = stringCollection.secondScreenText.independencebuttontext.observedText;
				
			}
			else if(currentState == 'showCsvState'){
				
				panelHelpText.text = stringCollection.secondScreenText.commonText.nparcolumnloadText;
				contingencyTableCheck = new CheckBox;
				contingencyTableCheck.label = "This is a Contingency Table";
				csvOptionsGroup.addElement(contingencyTableCheck);
				contingencyTableCheck.addEventListener(Event.CHANGE, checkBoxSelectedEventHandler);
				
				spacer = new Spacer;
				spacer.percentHeight = 8;
				csvOptionsGroup.addElement(spacer);
			
				selectColumnLabel1 = new Label;
				selectColumnLabel1.text = "Select the first Column: ";
				csvOptionsGroup.addElement(selectColumnLabel1);
				
				comboBox1 = new ComboBox;
				comboBox1.dataProvider = columnNames;
				comboBox1.percentWidth = 90;
				comboBox1.addEventListener(IndexChangeEvent.CHANGE,columnSelected);
				csvOptionsGroup.addElement(comboBox1);
				
				
				missingValueInput1 = new TextInput;
				missingValueInput1.prompt = "Replace missing Values by...";
				missingValueInput1.percentWidth = 90;
				csvOptionsGroup.addElement(missingValueInput1);
				
												
				var spacer:Spacer = new Spacer;
				spacer.percentHeight = 5;
				csvOptionsGroup.addElement(spacer);
				
				selectColumnLabel2 = new Label;
				selectColumnLabel2.text = "Select the second Column: ";
				csvOptionsGroup.addElement(selectColumnLabel2);
				
				
				comboBox2 = new ComboBox;
				comboBox2.dataProvider = columnNames;
				csvOptionsGroup.addElement(comboBox2);
				comboBox2.percentWidth = 90;
				comboBox2.addEventListener(IndexChangeEvent.CHANGE,columnSelected);
				
				missingValueInput2 = new TextInput;
				missingValueInput2.prompt = "Replace missing Values by...";
				missingValueInput2.percentWidth = 90;
				csvOptionsGroup.addElement(missingValueInput2);
				
			
				selectColumnLabel1.visible = true;
				comboBox1.visible = true;
				selectColumnLabel2.visible = true;
				comboBox2.visible = true;
				missingValueInput1.visible = true;
				missingValueInput2.visible = true;
			}
			
			else if(currentState == 'editCsvState'){
				if(!contingencyTableCheck.selected){
					editCsvGrid.columns = loadColumnName();
					editCsvGrid.dataProvider = loadDataProviderFormR();
				}
				else{
					editCsvGrid.columns = csvGrid.columns;
					editCsvGrid.dataProvider = csvGrid.dataProvider;
				}
				
				editCsvGrid.visible = true;	
			}
			
			else if(currentState == 'state2'){
				
				panelHelpText.text = stringCollection.secondScreenText.commmonText.significaneText;
				panelHelpText.text += "\n" + stringCollection.secondScreenText.commmonText.nparhypothesisText;
				var hypothesisLabel:Label = new Label;
				hypothesisLabel.text = "The Null hypothesis is that the variables are independent. The alternate hypothesis would be vice versa."
				hypothesisPanelGroup.addElementAt(hypothesisLabel,0);
				significanceValue = significanceTextInput.text;
				super.backboneStateChangeCompleteHandler(event);
			}
			
			else{
				
			}
		}
		
		private function loadColumnName():ArrayList
		{
			// TODO Auto Generated method stub
			var columnNames:Array = contingencyTableResult[0].split(","); 
			var columns:ArrayList = new ArrayList;
			for(var i:int = 0; i<columnNames.length; i++){
				var dataGridColumn:GridColumn = new GridColumn;
				dataGridColumn.width = 80;
				if(i == 0){
				dataGridColumn.dataField = "Levels";
				}
				else{
					dataGridColumn.dataField = columnNames[i-1];
				}
				columns.addItem(dataGridColumn);
			}
			return columns;
		}
		
		protected function checkBoxSelectedEventHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			if(contingencyTableCheck.selected){
				if(isContingency()){
				selectColumnLabel1.visible = false;
				selectColumnLabel1.visible = false;
				comboBox1.visible = false;
				comboBox2.visible = false;
				missingValueInput1.visible = false;
				missingValueInput2.visible = false;
				currentState = 'editCsvState';
				}
				
				else{
					Alert.show("The selected file is not in the recommended format.The row values, except the first row, should be numerical " +
						"\nPlease change the csv file to the correct format and upload again.","Unknown Format!");
					contingencyTableCheck.selected = false;
				}
			}
			else{
				currentState = 'showCsvState';
			}
		}
		
		private function isContingency():Boolean
		{
			// TODO Auto Generated method stub
			var tmpdataprovider:ListCollectionView = ListCollectionView(csvGrid.dataProvider)
			var tmpColNames:Array = columnNames.source;
			for(var i:int=0;i<csvGrid.dataProviderLength;i++){
				for(var j:int = 1; j<csvGrid.columnsLength;j++){
					if(isNaN(Number(tmpdataprovider.getItemAt(i)[tmpColNames[j]]))){
						return false
					}
				}
			}
			return true;
		}
		
		protected function columnSelected(event:IndexChangeEvent):void
		{
			// TODO Auto-generated method stub
			if(comboBox1.selectedIndex==-3 || comboBox2.selectedIndex ==-3){
				comboBox1.selectedIndex=-1;
				comboBox2.selectedIndex=-1;
			}
			else if(comboBox1.selectedIndex != -1 && comboBox2.selectedIndex != -1){
				proceedButton.enabled = true;
			}
			if(comboBox1.selectedIndex != -1)
				missingValueInput1.text = 'NULL';
			if(comboBox2.selectedIndex != -1)
				missingValueInput2.text = 'NULL';
		}		
		
		private function loadDataProviderFormR():ArrayCollection
		{
			var columnNames:Array = contingencyTableResult[0].split(","); 
			var Clength:int  = columnNames.length;
			var editedCsvData:ArrayCollection = new ArrayCollection;
			var levels:Array = contingencyTableResult[1].split(",");
			var numElements:int = 0;
			
			//row iteration. each new i indicates a new row
			for(var i:int=0;i<levels.length-1;i++){
				var obj:Object = new Object;
				//column iteration
				for(var j:int =0;j<Clength;j++){
					if(j == 0){
						obj["Levels"] = levels[i];
					}
					else{
						obj[columnNames[j-1]]= contingencyTableResult[2].split(",")[numElements];
						numElements++;
					}
					
				}
				editedCsvData.addItem(obj);
			}
			return editedCsvData;
		}
		
		override protected function proceedButtonClickHandler(event:MouseEvent):void
		{
			var rFile:String = File.applicationDirectory.resolvePath("working/tabulate.R").nativePath;
			args = new Vector.<String>;
			args.push(rFile);
			args.push("independence");
			args.push(filePath.text);
			
			if(comboBox1.selectedIndex == comboBox2.selectedIndex){
				Alert.show("Please Select different Columns");
			}
			else{
				if(missingValueInput1.text == ""){
					missingValueInput1.errorString = "Enter a value";
				}
				else if(missingValueInput2.text == ""){
					missingValueInput2.errorString = "Enter a value";
				}
				else{
					missingValueInput1.errorString = "";
					missingValueInput2.errorString = "";
					args.push(comboBox1.selectedItem);
					args.push(comboBox2.selectedItem);
					
					args.push(missingValueInput1.text);
					args.push(missingValueInput2.text);
					
					tabulateDataFlag = true;
					
					super.proceedButtonClickHandler(event);
				}
			}
		}
		
		
		override protected function computeButtonClickHandler(event:MouseEvent):void
		{
			var rFile:String = File.applicationDirectory.resolvePath("working/chisquared.r").nativePath;
			args = new Vector.<String>;
			args.push(rFile);
			args.push("independence");
			args.push(File.applicationStorageDirectory.nativePath+"\\contingency.csv");
			
			super.computeButtonClickHandler(event);
		}
	}
}