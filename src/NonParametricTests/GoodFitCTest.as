package NonParametricTests
{
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.controls.Alert;
	import mx.controls.Spacer;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridDragProxy;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.gridClasses.DefaultGridItemEditor;
	import spark.components.gridClasses.GridColumn;
	import spark.events.GridItemEditorEvent;
	import spark.events.IndexChangeEvent;

	
	public class GoodFitCTest extends NonParametricBackbone
	{
		protected var selectColumnLabel:Label;
		protected var comboBox:ComboBox;
		protected var missingValueInput:TextInput;
		protected var spacer:Spacer;
		protected var contingencyTableCheck:CheckBox;
		protected var columnNamesforCTable:Array = new Array("Level","Observed Frequency","Expected Probability")		
		private var significanceValue:String;
		
		public function GoodFitCTest()
		{
			super();
		}
		
		override protected function backbonecreationCompleteHandler(event:FlexEvent):void
		{
			
			dataButton.visible = true;
			orLabel.visible = true;
			panelHelpText.text = stringCollection.secondScreenText.goodnessbuttontext.observedText;
		}
		
		
		override protected function backboneStateChangeCompleteHandler(event:FlexEvent):void{
			if(currentState == 'showCsvState'){
				
				panelHelpText.text = stringCollection.secondScreenText.commonText.nparcolumnloadText;
				if(columnNames.length == 3 && !contingencyTableCheck){
					contingencyTableCheck = new CheckBox;
					contingencyTableCheck.label = "This is a Contingency Table";
					csvOptionsGroup.addElement(contingencyTableCheck);
					contingencyTableCheck.addEventListener(Event.CHANGE, checkBoxSelectedEventHandler);
					
					spacer = new Spacer;
					spacer.percentHeight = 8;
					csvOptionsGroup.addElement(spacer);
				}
				
				selectColumnLabel = new Label;
				selectColumnLabel.text = "Select a Column: ";
				csvOptionsGroup.addElement(selectColumnLabel);
				
				comboBox = new ComboBox;
				comboBox.dataProvider = columnNames;
				csvOptionsGroup.addElement(comboBox);
				comboBox.percentWidth = 85;
				comboBox.addEventListener(IndexChangeEvent.CHANGE,columnSelected);
				
				spacer = new Spacer;
				spacer.percentHeight = 5;
				csvOptionsGroup.addElement(spacer);
				
				missingValueInput = new TextInput;
				missingValueInput.prompt = "Replace missing Values by...";
				missingValueInput.percentWidth = 85;
				csvOptionsGroup.addElement(missingValueInput);
				
				selectColumnLabel.visible = true;
				comboBox.visible = true;
				missingValueInput.visible = true;
				
			}
			else if(currentState == 'editCsvState'){
				
				panelHelpText.text = stringCollection.secondScreenText.goodnessbuttontext.expectedTest;
				
				editCsvGrid.columns = loadColumnName();
				if(enterDataFlag){
					
					editCsvGrid.editable = true;
					editCsvGrid.dataProvider = new ArrayCollection;
					editCsvGrid.dataProvider.addItem(createNewRow());
					editCsvGrid.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE,onItemEdit);
				}
				else{
					editCsvGrid.editable = true;
					editCsvGrid.dataProvider = loadDataProviderFormR();
				}
				editCsvGrid.visible = true;	
				
			}
			else if(currentState == 'state2'){
				panelHelpText.text = stringCollection.secondScreenText.commmonText.significaneText;
				panelHelpText.text += "\n" + stringCollection.secondScreenText.commmonText.nparhypothesisText;
				var hypothesisLabel:Label = new Label;
				hypothesisLabel.text = "The Null hypothesis is that the data fits the expected values. The alternate hypothesis would be vice versa."
				hypothesisPanelGroup.addElementAt(hypothesisLabel,0);
				super.backboneStateChangeCompleteHandler(event);
			}
			else{
				
			}
			
		}
		
		protected function onItemEdit(event:GridItemEditorEvent):void
		{
			// TODO Auto-generated method stub
			if(event.rowIndex == editCsvGrid.dataProviderLength-1 && event.columnIndex == 2 ){
				editCsvGrid.dataProvider.addItem(createNewRow());
			}
				
		}
		
		protected function checkBoxSelectedEventHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			if(contingencyTableCheck.selected){
				if(columnNamesforCTable.toString() == columnNames.toString()){
					currentState = 'state2';
					editCsvGrid.dataProvider = csvGrid.dataProvider;
					editCsvGrid.visible = true;
				}
				else{
					Alert.show("The selected file is not in the recommended format.\nThe Column names should be \"Level\", \"Observed Frequency\" and \"Expected Probability\".\n" +
						"Please change the csv file to the correct format and upload again.","Unknown Format!");
					contingencyTableCheck.selected = false;
					
				}
			}
			else{
				currentState = 'showCsvState';
			}
		}
		
		
		protected function columnSelected(event:IndexChangeEvent):void
		{
			if(comboBox.selectedIndex==-3){
				comboBox.selectedIndex=-1;
			}
			else{
				proceedButton.enabled = true;
				missingValueInput.text = 'R';
				missingValueInput.selectAll();
			}
		}
		
		private function loadDataProviderFormR():ArrayCollection
		{
			// TODO Auto Generated method stub
			var editedCsvData:ArrayCollection = new ArrayCollection;
			var levels:Array = contingencyTableResult[0].split(",");
			for(var i:int=0;i<levels.length-1;i++){
				var obj:Object = new Object;
				for(var j:int =0;j<2;j++){
					obj[columnNamesforCTable[j]]= contingencyTableResult[j].split(",")[i];
				}
				obj[columnNamesforCTable[2]] = "";
				editedCsvData.addItem(obj);
			}
			return editedCsvData;
		}
		
		private function createNewRow():Object
		{
			var obj:Object = new Object;
			for(var i:int =0; i<3;i++){
				obj[columnNamesforCTable[i]] = "";
			}
			return obj;
		}
		
		protected function loadColumnName():ArrayList{
			var dataGridColumn:GridColumn = new GridColumn;
			var columns:ArrayList = new ArrayList;
			dataGridColumn.width = 80;
			dataGridColumn.dataField = columnNamesforCTable[0];
			columns.addItem(dataGridColumn);
			dataGridColumn = new GridColumn;
			dataGridColumn.width = 140;
			dataGridColumn.dataField = columnNamesforCTable[1];
			columns.addItem(dataGridColumn);
			dataGridColumn = new GridColumn;
			dataGridColumn.width = 140;
			dataGridColumn.dataField = columnNamesforCTable[2];
			dataGridColumn.editable=true;
			columns.addItem(dataGridColumn);
			
			return columns;
		}
		
		override protected function proceedButtonClickHandler(event:MouseEvent):void
		{
			if(missingValueInput.text ==""){
				missingValueInput.errorString = "Enter a value"
			}
			else{
				missingValueInput.errorString = "";
				var rFile:String = File.applicationDirectory.resolvePath("working/tabulate.R").nativePath;
				args = new Vector.<String>;
				args.push(rFile);
				args.push("goodfittest");
				args.push(filePath.text);
				tabulateDataFlag = true;
				
				args.push(comboBox.selectedItem);
				args.push(missingValueInput.text);
				
				super.proceedButtonClickHandler(event);
			}
		}
		
		override protected function proceedButton2_clickHandler(event:MouseEvent):void
		{
			var expectedProb:Number = 0;
			var tmpdataprovider:ListCollectionView = ListCollectionView(editCsvGrid.dataProvider)
			for(var i:int=0;i<editCsvGrid.dataProviderLength;i++){
				if(tmpdataprovider.getItemAt(i)[0] != "")
					expectedProb += Number(tmpdataprovider.getItemAt(i)["Expected Probability"]);
			}
			if(expectedProb != 1){
				Alert.show("Expected Probabilities must sum to 1","Error");
			}
			else{
				if(enterDataFlag){
					editCsvGrid.dataProvider.removeItemAt(tmpdataprovider.length-1);
				}
				super.proceedButton2_clickHandler(event);
			}
		}
		
		override protected function computeButtonClickHandler(event:MouseEvent):void
		{
			
			var rFile:String = File.applicationDirectory.resolvePath("working/chisquared.r").nativePath;
			args = new Vector.<String>;
			args.push(rFile);
			args.push("goodfittest");
			args.push(File.applicationStorageDirectory.nativePath+"\\contingency.csv");
			
			
			super.computeButtonClickHandler(event);
			
		}
	}
}