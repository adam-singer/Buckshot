//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

/**
* A flexible layout container element supporting column/row positioning for child elements.
*
* **Grid works, but is not yet in it's final form.**
*
* ## Lucaxml Example Usage:
*     <grid>
*         <columndefinitions>
*             <columndefinition width="35"></columndefinition> <!-- A fixed column in pixels -->
*             <columndefinition width="auto"></columndefinition> <!-- Column auto sizes to widest element -->
*             <columndefinition width="*1"></columndefinition> <!-- A weighted portion of available space -->
*             <columndefinition width="*2"></columndefinition> <!-- A weighted portion of available space -->
*         </columndefinitions>
*         <rowdefinitions>
*             <rowdefinition height="35"></rowdefinition> <!-- A fixed row in pixels -->
*             <rowdefinition height="auto"></rowdefinition> <!-- Row auto sizes to widest element -->
*             <rowdefinition height="*1"></rowdefinition> <!-- A weighted portion of available space -->
*             <rowdefinition height="*2"></rowdefinition> <!-- A weighted portion of available space -->
*         </rowdefinitions>
*         <textblock grid.row="2" grid.column="1" text="hello world!"></textblock>
*     </grid> 
*
* ## See Also:
* * [RowDefinition]
* * [ColumnDefinition]
* * [GridUnitType]
* * [GridLength]
*/
class Grid extends Panel{
static final String noDirectGridCellExceptionMessage = "GridCell cannot be added directly to Grid.";
final List<_GridCell> _internalChildren;

/// Represents a collection of [ColumnDefinition]s.
FrameworkProperty columnDefinitionsProperty;
/// Represents a collection of [RowDefinitions]s.
FrameworkProperty rowDefinitionsProperty;

/// Represents the column assignment of an element within the grid.
static AttachedFrameworkProperty columnProperty; 
/// Represents the row assignment of an element within the grid.
static AttachedFrameworkProperty rowProperty;
/// Represents the column span of an element within the grid.
static AttachedFrameworkProperty columnSpanProperty;
/// Represents the row span of an element within the grid.
static AttachedFrameworkProperty rowSpanProperty;

/// Overidden [BuckshotObject] method.
FrameworkObject makeMe() => new Grid();

Grid() :
_internalChildren = new List<_GridCell>()
{
  _Dom.appendBuckshotClass(_component, "grid");
  
  columnDefinitionsProperty = new FrameworkProperty(this, "columnDefinitions", (ObservableList<ColumnDefinition> list){
    _updateColumnLayout(actualWidth);
  }, new ObservableList<ColumnDefinition>());
  
  rowDefinitionsProperty = new FrameworkProperty(this, "rowDefinitions", (ObservableList<RowDefinition> list){
    _updateRowLayout(actualHeight);
  }, new ObservableList<RowDefinition>());
  
  children.listChanged + _onChildrenChanging;
  
  columnDefinitions.listChanged + (_,__) => _updateColumnLayout(actualWidth);
  rowDefinitions.listChanged + (_,__) => _updateRowLayout(actualHeight);
  
  widthProperty.propertyChanging + (_, __) => _updateColumnLayout(actualWidth);
  heightProperty.propertyChanging + (_, __){
    _updateRowLayout(actualHeight);
  };
} 

/// Gets the [columnDefinitionsProperty] [ObservableList].
ObservableList<ColumnDefinition> get columnDefinitions() => getValue(columnDefinitionsProperty);

/// Gets the [rowDefinitionsProperty] [ObservableList].
ObservableList<RowDefinition> get rowDefinitions() => getValue(rowDefinitionsProperty);

void _onChildrenChanging(Object _, ListChangedEventArgs args){
  
  args.oldItems.forEach((item){
    var result = _internalChildren.filter((gc) => gc.content === item);
  
    if (result.length != 1) 
      throw new FrameworkException("Deleted element not found in internal Grid collection.");
  
    result[0].removeChild(item);
    result[0]._component.remove();
    item.parent = null;
  });
  
  
  args.newItems.forEach((item){   
    //create a virtual container for each element
    _GridCell newGC = new _GridCell();
    newGC.content = item;

    newGC._component.style.position = "absolute";
    
    _internalChildren.add(newGC);
         
    _component.nodes.add(newGC._component);
    //_positionElement(newGC);
    
  });
  
  updateLayout();
}

num _totalLengthOf(List<GridLayoutDefinition> definitions){
  num total = 0;
 
  definitions.forEach((item){
    total += item._adjustedLength;
  });
  
  return total;
}

/// Overidden [FrameworkObject] method.
void updateLayout(){

  _updateMeasurements();
  
  window.requestLayoutFrame((){
    _updateRowLayout(actualHeight);
    
    _updateColumnLayout(actualWidth);    
  });
  
} 

void _updateMeasurements(){
  _internalChildren.forEach((child){
    child.updateMeasurement();
  });
}

// Updates the column layout of the Grid based on given [gridWidth]
void _updateColumnLayout(num gridMeasurement){
  if (!_isLoaded) return;
   
  num gridWidth = gridMeasurement;
  
  if (columnDefinitions.length == 0){
    //handle case where no columnDefinitions are set
    //assign all elements to a ghost column that is the same width as the grid
    
    _internalChildren.forEach((child){
      child.margin = new Thickness.specified(child.margin.top, 0, 0, 0);
      child.width = gridWidth;    
    });
    
    return;
  }
     
    num totalPixelValue = 0;
    num totalStarValue = 0;
    ColumnDefinition lastStar = null;
    
    //initialize values for column types
    columnDefinitions.forEach((ColumnDefinition c){
      if (c.width.gridUnitType == GridUnitType.pixel){
        c._adjustedLength = c.width.value;    
        //summing the total pixels used by fixed column values
        totalPixelValue += c.width.value; 
      }
      else if (c.width.gridUnitType == GridUnitType.star){
        totalStarValue += c.width.value; //generating a denominator for later actual width calculation
        lastStar = c;
      }
      else if (c.width.gridUnitType == GridUnitType.auto){
        num widestAuto = 0;
        
        //measure the largest child for the current column
        _internalChildren
          .filter((child){
            //children that span outside the column are excluded
            return Grid.getColumn(child.content) == columnDefinitions.indexOf(c, 0)
                    && Grid.getColumnSpan(child.content) < 2;
          })
          .forEach((FrameworkElement child){
            num childWidth = child.mostRecentMeasurement.client.width;
            if (childWidth > widestAuto) 
              widestAuto = childWidth;
          });
        
        c._adjustedLength = widestAuto;
        totalPixelValue += widestAuto;
      }
    });    

    num availColWidth = gridWidth - totalPixelValue;
    
    //now determine the offsets for each column
    num ii = 0;
    num totalStarLength = 0;
    columnDefinitions.forEach((ColumnDefinition c){
      
      // if star type calculate adjusted length
      if (c.width.gridUnitType == GridUnitType.star){
        if (c === lastStar){
          c._adjustedLength = (availColWidth - totalStarLength);
        }
        else{
          c._adjustedLength = ((availColWidth * (c.width.value / totalStarValue)).round());
          totalStarLength += c._adjustedLength;
        }
      }
      
      //calculate the offset for each column
      num id = ii - 1;
      c._adjustedOffset = ii == 0 ? 0 : columnDefinitions[id]._adjustedOffset + columnDefinitions[id]._adjustedLength;

      ii++;
    });
    
    //set child wrappers to column offsets
    _internalChildren.forEach((child){
      num colIndex = Grid.getColumn(child.content);
           
      num childColumnSpan = Grid.getColumnSpan(child.content);
      child.margin = new Thickness.specified(child.margin.top, 0, 0, columnDefinitions[colIndex]._adjustedOffset);
      
      if (childColumnSpan > 1){
        if (childColumnSpan > columnDefinitions.length - colIndex)
          childColumnSpan = columnDefinitions.length - colIndex;
        child.width = _totalLengthOf(columnDefinitions.getRange(colIndex, childColumnSpan));
      }else{
        child.width = columnDefinitions[colIndex]._adjustedLength;
      }
      child.updateLayout();
    });
}  

// Updates the row layout of the Grid based on the given [gridHeight]
void _updateRowLayout(num gridHeight){
  
  if (!_isLoaded) return;

  if (rowDefinitions.length == 0){
    //handle case where no rowDefinitions are set
    //assign all elements to a ghost row that is the same height as the grid
  
    _internalChildren.forEach((child){
      child.margin = new Thickness.specified(0, 0, 0, child.margin.left);
      child.height = gridHeight;
    });
    
    return;
  }

  num totalPixelValue = 0;
  num totalStarValue = 0;   
  RowDefinition lastStar = null;
  
  //initialize values for rows
  rowDefinitions.forEach((RowDefinition c){
    if (c.height.gridUnitType == GridUnitType.pixel){
      c._adjustedLength = c.height.value;
      totalPixelValue += c.height.value;
    }
    else if (c.height.gridUnitType == GridUnitType.star){
      totalStarValue += c.height.value;
      lastStar = c;
    }
    else if (c.height.gridUnitType == GridUnitType.auto){     
      num widestAuto = 0;
      
      //measure the largest child for the current column
      _internalChildren
        .filter((_GridCell child){
          //children that span outside the row are excluded
          return Grid.getRow(child.content) == rowDefinitions.indexOf(c, 0)
                && Grid.getRowSpan(child.content) < 2;
        })
        .forEach((_GridCell child){
          num childHeight = child._getHeight();
          if (childHeight > widestAuto) 
            widestAuto = childHeight;
        });
      
      c._adjustedLength = widestAuto;
      totalPixelValue += widestAuto;        
    }
  });
  
  num availRowHeight = gridHeight - totalPixelValue;
  num ii = 0;
  num totalStarLength = 0;
  rowDefinitions.forEach((RowDefinition c){
    
    if (c.height.gridUnitType == GridUnitType.star){
      if (c === lastStar){
        c._adjustedLength = (availRowHeight - totalStarLength); 
      }else{
        c._adjustedLength = ((availRowHeight * (c.height.value / totalStarValue)).round());  
        totalStarLength += c._adjustedLength;
      }
    }
    
    //calculate the offset
    num id = ii - 1;
    c._adjustedOffset = ii == 0 ? 0 : (rowDefinitions[id]._adjustedOffset + rowDefinitions[id]._adjustedLength);      
    ii++;
  });    
  
  //assign child wrappers to row offsets
  _internalChildren.forEach((child){
    num rowIndex = Grid.getRow(child.content);
    num childRowSpan = Grid.getRowSpan(child.content);
    child.margin = new Thickness.specified(rowDefinitions[rowIndex]._adjustedOffset, 0, 0, child.margin.left);

    if (childRowSpan > 1){
      if (childRowSpan > rowDefinitions.length - rowIndex)
        childRowSpan = rowDefinitions.length - rowIndex;
      
      child.height = _totalLengthOf(rowDefinitions.getRange(rowIndex, childRowSpan));
    }else{
      child.height = rowDefinitions[rowIndex]._adjustedLength;
    }
    
    child.updateLayout();
  });

  //db("row build time: ${_sw.elapsedInMs()}", this);

}


//attached properties

/**
* Attaches a [column] value to the given [element].
* This will be used later by Grid to layout the element at the correct location. */
static void setColumn(FrameworkElement element, num column){
  if (element == null) return;
  
  if (column < 0) column = 0;
  
  if (Grid.columnProperty == null){
    Grid.columnProperty = new AttachedFrameworkProperty("column", (FrameworkElement e, num value){     
    });
  }
  
  setAttachedValue(element, columnProperty, column);
}


static num getColumn(FrameworkElement element){
  if (element == null) return 0;
  
  var value = getAttachedValue(element, Grid.columnProperty);

  if (Grid.columnProperty == null || value == null)
    Grid.setColumn(element, 0);
  
  return getAttachedValue(element, columnProperty);
}

static void setRow(FrameworkElement element, num row){
  if (element == null) return;
  
  if (row < 0) row = 0;
  
  if (Grid.rowProperty == null){
    Grid.rowProperty = new AttachedFrameworkProperty("row", (FrameworkElement e, num value){
      
    });
  }
  
  setAttachedValue(element, rowProperty, row);
}

static num getRow(FrameworkElement element){
  if (element == null) return 0;
  
  var value = getAttachedValue(element, Grid.rowProperty);
  
  if (Grid.rowProperty == null || value == null)
    Grid.setRow(element, 0);
  
  return getAttachedValue(element, rowProperty);
}

static void setColumnSpan(FrameworkElement element, num columnSpan){
  if (element == null) return;
  
  if (columnSpan < 0) columnSpan = 0;

  if (Grid.columnSpanProperty == null){
    Grid.columnSpanProperty = new AttachedFrameworkProperty("columnSpan", (FrameworkElement e, num value){
      
    });
  }
  
  setAttachedValue(element, columnSpanProperty, columnSpan);
}

static num getColumnSpan(FrameworkElement element){
  if (element == null) return 0;

  var value = getAttachedValue(element, Grid.columnSpanProperty);
  
  if (Grid.columnSpanProperty == null || value == null)
    Grid.setColumnSpan(element, 0);
  
  return getAttachedValue(element, Grid.columnSpanProperty);
}

static void setRowSpan(FrameworkElement element, num rowSpan){
  if (element == null) return;
  
  if (rowSpan < 0) rowSpan = 0;
  
  if (Grid.rowSpanProperty == null){
    Grid.rowSpanProperty = new AttachedFrameworkProperty("rowSpan", (FrameworkElement e, num value){
      
    });
  }
  
  setAttachedValue(element, rowSpanProperty, rowSpan);
}

static num getRowSpan(FrameworkElement element){
  if (element == null) return 0;
  
  var value = getAttachedValue(element, Grid.rowSpanProperty);
  
  if (Grid.rowSpanProperty == null || value == null)
    Grid.setRowSpan(element, 0);
  
  return getAttachedValue(element, rowSpanProperty);
}

String get type() => "Grid";
}