# infinite_widgets

Infinite layout widgets like lists, grids...

## Infinite list
InfiniteListView has same attributes as a normal flutter ListView widget.

```
InfiniteListView.separated(
        itemBuilder: (context, index) {
          return Text('$index', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
        },
        itemCount: _data.length, // Current itemCount you have
        hasNext: _data.length < 200, // let the widget know if you have more data to show or not
        nextData: this.loadNextData, // callback called when end to the list is reach and hasNext is true
        separatorBuilder: (context, index) => Divider(height: 1),
      ),
    );
```

You can specify the last loading row by providing `loadingWidget`.

You can interact with the trigger to load additional data by default it's `300` but you can override it with `scrollThreshold`.

## Infinite grid 
InfiniteGridView has same attributes as a normal flutter GridView widget.
```
InfiniteGridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) {
          return Text('$index', style: TextStyle(color: Colors.white));
        },
        itemCount: _data.length, // Current itemCount you have
        hasNext: _data.length < 200, // let the widget know if you have more data to show or not
        nextData: this.loadNextData, // callback called when end to the list is reach and hasNext is true
      ),
    );
```

You can specify the last loading row by providing `loadingWidget`.

You can interact with the trigger to load additional data by default it's `300` but you can override it with `scrollThreshold`. 
