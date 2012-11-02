part of core_buckshotui_org;

// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
* Defines an observable version of List<T> that fires an event whenever items are added/removed from the list.
* Note that the insertRange() method is not supported in this sub class.
*
* See [List<T>] for information about specific methods.
*/
class ObservableList<T> implements List<T>{
  final FrameworkEvent<ListChangedEventArgs<T>> listChanged;
  final List<T> _list;

  ObservableList() :
    _list = new List<T>(),
    listChanged = new FrameworkEvent<ListChangedEventArgs<T>>();

  void operator[]=(int index, T value){
    var oldValue = _list[index];

    _list[index] = value;

    _notifySingleOldAndNew(oldValue, value);
  }

  T operator[](int index) => _list[index];

  bool get isEmpty => _list.isEmpty;

  void forEach(void f(element)) => _list.forEach(f);

  bool contains(T element) => _list.contains(element);

  Collection map(f(T element)) => _list.map(f);

  Collection<T> filter(bool f(T element)) => _list.filter(f);

  bool every(bool f(T element)) => _list.every(f);

  bool some(bool f(T element)) => _list.some(f);

  Iterator<T> iterator() => _list.iterator();

  int indexOf(T element, [int start = 0]) => _list.indexOf(element, start);

  int lastIndexOf(T element, [int start = 0]) => _list.lastIndexOf(element, start);

  int get length => _list.length;

  //TODO Fire events if newLength truncates elements.
  void set length(int newLength) {_list.length = newLength;}

  List getRange(int start, int length) => _list.getRange(start, length);

  dynamic reduce(dynamic initialValue,
                 dynamic combine(dynamic previousValue, T element)) =>
                     _list.reduce(initialValue, combine);

//  T removeAt(int index){
//    final removed = _list.removeAt(index);
//    _notifySingleOld(removed);
//    return removed;
//  }

  void add(T element){
    _list.add(element);
    _notifySingleNew(element);
  }

  T removeAt(int index){
    final removed = _list.removeAt(index);
    _notifySingleOld(removed);
    return removed;
  }

  void remove(T element){
    if (_list.indexOf(element) == -1) return;

    _list.removeRange(_list.indexOf(element), 1);

    _notifySingleOld(element);
  }

  void addAll(Collection<T> elements){
    _list.addAll(elements);
    listChanged.invoke(this, new ListChangedEventArgs<T>(new List<T>(), elements));
  }

  void clear(){
    Collection<T> c = _list;
    _list.clear();
    listChanged.invoke(this, new ListChangedEventArgs<T>(c, new List<T>()));
  }

  T removeLast(){
    T item = _list.last;
    _list.removeLast();
    _notifySingleOld(item);
    return item;
  }

  T get last => _list.last;

  void sort([Comparator compare = Comparable.compare]) => _list.sort(compare);

  void insertRange(int start, int length, [T initialValue = null]){
    throw new UnsupportedError("insertRange not supported in ObservableList");
  }

  void addLast(T value) => _list.addLast(value);

  void removeRange(int start, int length){
    var l = getRange(start, length);
    _list.removeRange(start, length);

    listChanged.invoke(this, new ListChangedEventArgs<T>(l, new List<T>()));
  }

  void setRange(int start, int length, List<T> from, [int startFrom = 0]){
    var ol = getRange(start, length);
    _list.setRange(start, length, from, startFrom);

    listChanged.invoke(this, new ListChangedEventArgs<T>(ol, from.getRange(startFrom, from.length - startFrom)));
  }

  void _notifySingleOld(T oldItem){
    var ol = new List<T>();
    ol.add(oldItem);
    listChanged.invoke(this, new ListChangedEventArgs<T>(ol, new List<T>()));
  }

  void _notifySingleNew(T newItem){
    List<T> nl = new List<T>();
    nl.add(newItem);
    listChanged.invoke(this, new ListChangedEventArgs<T>(new List<T>(), nl));
  }

  void _notifySingleOldAndNew(T oldItem, T newItem){
    var ol = new List<T>();
    var nl = new List<T>();
    ol.add(oldItem);
    nl.add(newItem);

    listChanged.invoke(this, new ListChangedEventArgs<T>(ol, nl));
  }

  String toString() => _list.toString();
}
