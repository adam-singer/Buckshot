// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* A flexible layout container element supporting column/row positioning for child elements.
*
* **Grid works, but is not yet in it's final form.**
*
* ## BuckshotXml Example Usage:
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
  Dom.appendBuckshotClass(rawElement, "grid");

  columnDefinitionsProperty = new FrameworkProperty(this, "columnDefinitions", (ObservableList<ColumnDefinition> list){
    _updateColumnLayout(actualWidth);
  }, new ObservableList<ColumnDefinition>());

  rowDefinitionsProperty = new FrameworkProperty(this, "rowDefinitions", (ObservableList<RowDefinition> list){
    _updateRowLayout(actualHeight);
  }, new ObservableList<RowDefinition>());

  children.listChanged + _onChildrenChanging;

  columnDefinitions.listChanged + (_,__) => _updateColumnLayout(actualWidth);
  rowDefinitions.listChanged + (_,__) => _updateRowLayout(actualHeight);

  measurementChanged + (_, MeasurementChangedEventArgs args){
    window.requestAnimationFrame((__) => updateLayout());
  };
}

/// Gets the [columnDefinitionsProperty] [ObservableList].
ObservableList<ColumnDefinition> get columnDefinitions() => getValue(columnDefinitionsProperty);

/// Gets the [rowDefinitionsProperty] [ObservableList].
ObservableList<RowDefinition> get rowDefinitions() => getValue(rowDefinitionsProperty);

void _onChildrenChanging(Object _, ListChangedEventArgs args){

  args.oldItems.forEach((FrameworkElement item){

    var p = item.parent;

    if (p == null || p is! _GridCell)
      throw new BuckshotException("Deleted element not found in internal Grid collection.");

    item.removeFromLayoutTree();

    p.rawElement.remove();
  });


  args.newItems.forEach((item){
    //create a virtual container for each element
    _GridCell newGC = new _GridCell();
    newGC.content = item;

    _internalChildren.add(newGC);

    newGC.addToLayoutTree(this);
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
    _updateRowLayout(this.mostRecentMeasurement.bounding.height);

    _updateColumnLayout(this.mostRecentMeasurement.bounding.width);
  });

}

void _updateMeasurements(){

  this.updateMeasurement();

  _internalChildren
    .forEach((child){
      child.content.updateMeasurement();
    });
  }

// Updates the column layout of the Grid based on given [gridWidth]
void _updateColumnLayout(num gridWidth){
  if (!_isLoaded) return;

  if (columnDefinitions.length == 0){
    //handle case where no columnDefinitions are set
    //assign all elements to a ghost column that is the same width as the grid

    _internalChildren.forEach((child){
      child.margin = new Thickness.specified(child.margin.top, 0, 0, 0);
      child.rawElement.style.width = '${gridWidth}px';
    //  db('width: ${child.rawElement.style.width}', this);
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
            return
                Grid.getColumn(child.content) == columnDefinitions.indexOf(c, 0)
                && Grid.getColumnSpan(child.content) < 2;
          })
          .forEach((_GridCell child){
            num childWidth = child.content.mostRecentMeasurement.bounding.width;
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

      //child.rawElement.style.left = '${columnDefinitions[colIndex]._adjustedOffset}px';
      child.margin = new Thickness.specified(child.margin.top, 0, 0, columnDefinitions[colIndex]._adjustedOffset);

      if (childColumnSpan > 1){
        if (childColumnSpan > columnDefinitions.length - colIndex)
          childColumnSpan = columnDefinitions.length - colIndex;
        child.rawElement.style.width = '${_totalLengthOf(columnDefinitions.getRange(colIndex, childColumnSpan))}px';
      }else{
        child.rawElement.style.width = '${columnDefinitions[colIndex]._adjustedLength}px';
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
      child.rawElement.style.height = '${gridHeight}px';
     // db('height: ${child.rawElement.style.height}', this);
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
          num childHeight = child.content.mostRecentMeasurement.bounding.height;
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
  _internalChildren.forEach((_GridCell child){
    num rowIndex = Grid.getRow(child.content);
    num childRowSpan = Grid.getRowSpan(child.content);

    //child.rawElement.style.top = '${rowDefinitions[rowIndex]._adjustedOffset}px';
    child.margin = new Thickness.specified(rowDefinitions[rowIndex]._adjustedOffset, 0, 0, child.margin.left);

    if (childRowSpan > 1){
      if (childRowSpan > rowDefinitions.length - rowIndex)
        childRowSpan = rowDefinitions.length - rowIndex;

      child.rawElement.style.height = '${_totalLengthOf(rowDefinitions.getRange(rowIndex, childRowSpan))}px';
    }else{
      child.rawElement.style.height = '${rowDefinitions[rowIndex]._adjustedLength}px';
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

  FrameworkObject.setAttachedValue(element, columnProperty, column);
}


static num getColumn(FrameworkElement element){
  if (element == null) return 0;

  var value = FrameworkObject.getAttachedValue(element, Grid.columnProperty);

  if (Grid.columnProperty == null || value == null)
    Grid.setColumn(element, 0);

  return FrameworkObject.getAttachedValue(element, columnProperty);
}

static void setRow(FrameworkElement element, num row){
  if (element == null) return;

  if (row < 0) row = 0;

  if (Grid.rowProperty == null){
    Grid.rowProperty = new AttachedFrameworkProperty("row", (FrameworkElement e, num value){

    });
  }

  FrameworkObject.setAttachedValue(element, rowProperty, row);
}

static num getRow(FrameworkElement element){
  if (element == null) return 0;

  var value = FrameworkObject.getAttachedValue(element, Grid.rowProperty);

  if (Grid.rowProperty == null || value == null)
    Grid.setRow(element, 0);

  return FrameworkObject.getAttachedValue(element, rowProperty);
}

static void setColumnSpan(FrameworkElement element, num columnSpan){
  if (element == null) return;

  if (columnSpan < 0) columnSpan = 0;

  if (Grid.columnSpanProperty == null){
    Grid.columnSpanProperty = new AttachedFrameworkProperty("columnSpan", (FrameworkElement e, num value){

    });
  }

  FrameworkObject.setAttachedValue(element, columnSpanProperty, columnSpan);
}

static num getColumnSpan(FrameworkElement element){
  if (element == null) return 0;

  var value = FrameworkObject.getAttachedValue(element, Grid.columnSpanProperty);

  if (Grid.columnSpanProperty == null || value == null)
    Grid.setColumnSpan(element, 0);

  return FrameworkObject.getAttachedValue(element, Grid.columnSpanProperty);
}

static void setRowSpan(FrameworkElement element, num rowSpan){
  if (element == null) return;

  if (rowSpan < 0) rowSpan = 0;

  if (Grid.rowSpanProperty == null){
    Grid.rowSpanProperty = new AttachedFrameworkProperty("rowSpan", (FrameworkElement e, num value){

    });
  }

  FrameworkObject.setAttachedValue(element, rowSpanProperty, rowSpan);
}

static num getRowSpan(FrameworkElement element){
  if (element == null) return 0;

  var value = FrameworkObject.getAttachedValue(element, Grid.rowSpanProperty);

  if (Grid.rowSpanProperty == null || value == null)
    Grid.setRowSpan(element, 0);

  return FrameworkObject.getAttachedValue(element, rowSpanProperty);
}

String get type() => "Grid";
}