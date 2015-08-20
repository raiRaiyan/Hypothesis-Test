package assets
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import spark.components.gridClasses.GridColumn;
	
	public class LoadCsvFiles
	{
		
		protected var fileStream:FileStreamWithLineReader = new FileStreamWithLineReader;
		/**
		 * The number of lines read in total.
		 * Manipulate this with the number of lines 
		 * displayed to get the actual rowcount.
		 * */
		protected var rowCount:uint;
		protected var previousPositionArray:Array;
		protected var colname:Array;
		protected var numRowsDisplayed:uint;
		
		public function LoadCsvFiles(file:File)
		{
			fileStream.open(file,FileMode.READ);
			rowCount = 0;
			colname = new Array;
			previousPositionArray = new Array;
		} 
		
		public function isBeginning():Boolean{
			if(fileStream.position == previousPositionArray[0]){
				return true;
			}
			return false;
		}
		
		/**Returns the column name of the csv file. 
		 * Use this only after the call 
		 * to loadColumnNames*/
		public function get columnNames():Array{
			return colname;
		}
		
		
		
		public function pushPosition():void{
			previousPositionArray.push(fileStream.position);
		}
		
		/** The number of rows the loader has read */
		public function get numRows():uint{
			return this.rowCount;
		}
		
		public function set numRows(value:uint):void{
			rowCount = value;
		}
		
		public function closeStream():void{
			fileStream.close();
		}
		
		public function setPreviousPosition():void{
			numRows = rowCount-2*numRowsDisplayed;
			previousPositionArray.pop();
			fileStream.position = previousPositionArray[previousPositionArray.length-1];
		}
		
		public function hasData():Boolean{
			if(fileStream.bytesAvailable){
				return true;
			}
			return false;
		}
		
		public function loadColumnName(width:uint):ArrayList{
			var str:String= fileStream.readUTFLine();
			colname = str.split(",");
			var col:ArrayList=new ArrayList;
			for(var i:int=0; i<colname.length;i++){
				var datag_col:GridColumn = new GridColumn();
				datag_col.dataField=colname[i];
				if(colname.length <= 6){
					datag_col.width = int(width/(colname.length+1));
				}
				else{
					datag_col.width = 70;
				}
				col.addItem(datag_col);
			}
			return col;
		}
		
		public function readLines(numLines:int):ArrayCollection
		{	
			
			var val_coll:ArrayCollection = new ArrayCollection;
			var str:String = new String;
			var lines:int = 0;
			while(lines< numLines){
				if(fileStream.bytesAvailable){
					if(rowCount == 0){
						numRowsDisplayed = numLines;
						previousPositionArray.push(fileStream.position);
					}
					str = fileStream.readUTFLine();
					rowCount += 1;					
					lines++;
					var obj:Object = new Object;
					var rowValues:Array = str.split(",");
					for(var j:int = 0;j<colname.length;j++){							
						obj[colname[j]] = rowValues[j];
					}
					val_coll.addItem(obj);
			}
			else{
				break;
			}
		}
		return val_coll;	
	}
}
}