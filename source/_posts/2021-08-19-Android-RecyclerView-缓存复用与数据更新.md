---
title: Android-RecyclerView-缓存复用与数据更新
categories:
  - 🌙基础学习
  - ⭐Android
abbrlink: f1832120
date: 2021-08-19 16:01:02
tags:
---

## 一、RecyclerView与ListView、ViewPager

### RecyclerView

A flexible view for providing a limited window into a large data set.

{% asset_img 1.webp %}

{% asset_img 2.webp %}

{% asset_img 3.webp %}

<!--more-->

一般步骤：

``` java
mRecyclerView.setLayoutManager(layoutManager); 
mRecyclerView.setAdapter(galleryAdapter); 
new PagerSnapHelper().attachToRecyclerView(mGalleryRecyclerView);
```

### ListView和RecyclerView

Recyclerview通过内部类Recycler管理的缓存，缓存的是ViewHolder（内部包含子View），这样在滑动时可以复用子View，在某些情况下，还可以复用子View绑定的数据。所以**本质上缓存是为了减少重复绘制View和绑定数据的时间，从而提高了滑动时的性能。**

ListView缓存机制，对应到屏幕上：

{% asset_img 4.webp %}

{% asset_img 5.webp %}

RecyclerView缓存机制，对应到屏幕上，以及可自定义部分：

{% asset_img 6.webp %}

{% asset_img 7.webp %}

| ListView的局限 | RecyclerView的优势 |
|  -----------  | -----------------  |
| 1. 纵向列表一种布局  | 1.默认支持Linear, Grid, Staggered Grid三种布局  |
| 2. 没有支持动画的API  | 2. ItemAnimator动画API |
| 3. 接口设计和系统不一致  | 3. 强制实现ViewHolder |
| 4. 没有强制实现ViewHolder  | 4. 解耦架构设计 |
| 5. 性能不如RecyclerView  | 5. 相比ListView更好的性能 |

**相似点：**

1. mActiveViews和mAttachedScrap功能相似，意义在于快速重用屏幕上可见的列表项ItemView，而不需要重新createView()和bindView()

2. mScrapView和mCachedViews+mReyclerViewPool功能相似，意义在于缓存离开屏幕的ItemView，目的是让即将进入屏幕的ItemView重用

3. RecyclerView的优势在于【mCacheViews的使用，可以做到屏幕外的列表项ItemView进入屏幕内时也无须bindView快速重用】；【mRecyclerPool可以供多个RecyclerView共同使用】，在特定场景下，如viewpager+多个列表页下有优势

- 总的来说，RecyclerView在特定场景下对ListView的缓存机制进行完善。

**不同点：**

1. RecyclerView缓存RecyclerView.ViewHolder，抽象可理解为：View+ViewHolder（避免每次createView时调用findViewById）+flag（标识状态）

2. ListView缓存View

### ViewPager和ViewPager2（RecyclerView）

ViewPager2 底层是用 RecycleView 实现（RecyclerView.Adapter）

RecyclerView的Adapter可以针对不同Item的ViewType来缓存不同的Item

例子：TabLayout 与 ViewPager2

---

## 二、RecyclerView在TV上的应用

### 原生RecyclerView使用时的局限性

在手机端使用RecyclerView比较简单，但是在TV端就会出现不少的问题，例如焦点显示不全，无法定位到某个position等等

{% asset_img 8.webp %}

#### RecyclerView刷新数据的时候，焦点错乱问题

**原因：**

（自认为是viewHolder复用的问题，跟数据刷新位置错乱类似）

**解决办法：**

1. adapter调用setHasStableIds(true)方法

    等同于调用了viewholder中的view的requestFocus()方法。

    相当于加了一个tag，tag不变的话，不用重新加载。但是set true后会使得列表的数据项重复，所以需要在Adapter里面重写getItemId。同时RecyclerView的notify方法图片加载时不闪烁。

2. 重写getItemId()方法,让每个view都有各自的id

    ``` java
    @Override
    public long getItemId(int position) {
    return position;
    }
    ```

3. RecyclerView的去掉动画

    ``` java
    mRecyclerView.setItemAnimator(null);
    ```

#### 长按遥控器RecyclerView快速滑动，焦点错乱问题

**原因：**

RecyclerView在长按遥控器的情况下会导致Item的焦点丢失或者说是飞到别的控件上。主要是因为RecyclerView设置适配器，将数据全部填充进去之后，并不会将所有的item的view创建出来，只会创建出显示和需要的item的View，没有显示的View很可能没有被创建。在滑动的过程中，下一个要获取焦点的view，还处于绘制渲染阶段（PFLAG_INVALIDATED，PFLAG_DIRTY_MASK），这个阶段的view是无法获取焦点的。

**解决办法：**

1. 自定义RecyclerView，拦截dispatchkeyEvent事件，对按键进行过滤，取消一些view还处于不能获取焦点的按键事件，并根据遥控器按钮操作来获取焦点

2. 比如监听了下键，判断展示数据的RecyclerView是否获得焦点了，接着判断了数据size是否为空，算出数据数量，最后一个item获取到焦点就拦截遥控下键，让焦点一直停留在最后一个item上，就不会出现焦点乱跑了

#### 解决RecyclerView 定位到某个item不获取焦点问题

**原因：**

RecyclerView提供了一个smoothScrollToPosition(int position)方法，该方法能滑到指定的position位置，但是实际该position处的item并没有获取焦点。

**解决办法：**

1. 定位到指定位置的item后，找到目标的item，并让其主动请求焦点

2. RecyclerView弹性滑动SmoothScroller中有onStart和onStop的回调，在onStop滑动结束的回调找到targetView，并让其请求焦点

#### Android TV 中RecyclerView聚焦Item实现居中功能

**需求：**

实现一种节目列表选中自动居中放大的功能

{% asset_img 9.webp %}

**方法1：** 重写RecyclerView的layoutManager的smoothScrollToPosition函数，该方法通过修改滑动Scroller里面的偏移量来达到居中的效果

**方法2：** 在adapter中给item添加一个聚焦的监听，然后对当前Item的坐标以及RecyclerView的位置计算出需要偏移的长度，最后调用RecyclerView的smoothScrollBy函数进行滚动。

---

## 三、RecyclerView缓存与复用原理

### 四级缓存

优先级又高到低依次是：

**ArrayList mAttachedScrap** → 缓存屏幕中可见范围的ViewHolder

**ArrayList mCachedViews** → 缓存滑动时即将与RecyclerView分离的ViewHolder，按子View的position或id缓存，默认最多存放2个

**ViewCacheExtension mViewCacheExtension** → 开发者自行实现的缓存

**RecycledViewPool mRecycledViewPool** → ViewHolder缓存池，本质上是一个SparseArray，其中Key是ViewType（Int类型），value存放的是ArrayList<ViewHolder>，默认每个ArrayList中最多存放5个ViewHolder

{% asset_img 10.webp %}

通过mAttachedScrap（1）、mCachedViews（2）获取的ViewHolder不需要重新创建布局及绑定数据

通过缓存池mRecyclerPool（4）获取的ViewHolder不需要重新创建布局，但是需要重新绑定数据

如果上述缓存中都没有获取到目标ViewHolder，那么就会回调Adapter#onCreateViewHolder创建布局，以及回调Adapter#onBindViewHolder来绑定数据。

| 缓存等级 | 是否需要回调createView() | 是否需要回调bindView() | 生命周期 | 备注 |
| - | - | - | - | - |
| mAttachedScrap | 否 | 否 | onLayout()周期内 | 用于屏幕内ItemView快速重用 |
| mCacheViews | 否 | 否 | 与mAdapter一致，当mAdapter被更换时，mCacheViews即被缓存至mRecyclerPool | 默认上限为2，即缓存屏幕外2个ItemView |
| mViewCacheExtension | | | | 不直接使用，需要用户自己定制，默认不实现 |
| mRecyclerPool | 否 | 是 | 与自身生命周期一致，不再被引用时即被释放 | 默认上限为5，技术上可以实现所有RecyclerViewPool共用同一个 |

### 源码走查

1. 复用

    | 布局 | 滑动 |
    | - | - |
    | RecyclerView.onLayout(...) | RecyclerView.onTouchEvent(...) |
    | -> RecyclerView.dispatchLayout() | -> MotionEvent.ACTION_MOVE |
    | -> RecyclerView.dispatchLayoutStep2() | -> RecyclerView.scrollByInternal(...) |
    | -> mLayout.onLayoutChildren(mRecycler, mState) | -> RecyclerView.scrollStep(...) |
    | -> LinearLayoutManager.onLayoutChildren(...) | -> LinearLayoutManager.scrollHorizontallyBy(...) |
    | -> LinearLayoutManager.fill(...) | -> LinearLayoutManager.scrollBy(...) | -> LinearLayoutManager.fill(...) |
    | -> LinearLayoutManager.layoutChunk(recycler, layoutState) | -> LinearLayoutManager.fill(...) |
    | -> LinearLayoutManager.LayoutState.next(recycler) | -> ...... |
    | -> RecyclerView.Recycler.getViewForPosition(int) |
    | -> Recycler.getViewForPosition(int, boolean) |
    | -> Recycler.tryGetViewHolderForPositionByDeadline(...) |

    {% asset_img 11.webp %}

2. 缓存

    没有缓存那怎么复用？所以去fill()复用前找缓存的方法函数。

    | 布局 |
    | - |
    | LinearLayoutManager.fill(...)之前 |
    | -> RecyclerView.detachAndScrapAttachedViews(...) |
    | -> RecyclerView.scrapOrRecycleView() |
    | -> recycler.recycleViewHolderInternal()和recycler.scrapView() |
    | -> 后者是有效时，加进第一级缓存，非本次重点 |
    | -> recycler.recycleViewHolderInternal() |
    | -> (cachedViewSize、recycleCachedViewAt()) |
    | -> addViewHolderToRecycledViewPool() |
    | -> getRecycledViewPool().putRecycledView() |
    | -> 已满直接return，未满就清除数据后add |

    {% asset_img 12.webp %}

### 补充

#### ViewCacheExtension的使用场景与实现

RecyclerView中的其他缓存：第一级缓存mAttachedScrap用来处理可见屏幕的缓存；第二级缓存mCachedViews里存储的数据虽然是根据position来缓存，但是里面的数据随时可能会被替换的；第四级缓存mRecyclerPool里按viewType去存储ArrayList<ViewHolder>，所以mRecyclerPool并不能按position去存储ViewHolder，而且从mRecyclerPool取出的View每次都要去走Adapter#onBindViewHolder去重新绑定数据。

所以假如现在需要在一个特定的位置（比如position=0位置）一直展示某个View，且里面的内容是不变的，那么最好的情况就是在特定位置时，既不需要每次重新创建View，也不需要每次都去重新绑定数据，上面的几种缓存显然都是不适用的，这种情况可以通过自定义缓存ViewCacheExtension实现上述需求。

ViewCacheExtension适用场景：ViewHolder位置固定、内容固定、数量有限时使用。

#### SparseArray

SparseArray是Android里为<Interger,Object>这样的Hashmap而专门写的类，目的是提高内存效率，其核心是折半查找函数。

SparseArray有两个优点：1. 避免了自动装箱（类似enum）2. 数据结构不会依赖于外部对象映射（数组数据结构来保存映射）。

---

## 四、RecyclerView刷新列表数据的notifyDatasetChange()为什么消耗资源比其他刷新方法多

### RecyclerView.Adapter中刷新数据的方法

1. notifyDataSetChanged()

    此方法跟ListView的Adapter的方法一样

2. notifyItemChanged(int position)

    当position位置的数据发生了改变时就会调用这个方法，就会回调对应position的onBindViewHolder()方法了，当然，因为ViewHolder是复用的，所以如果position在当前屏幕以外，因为没有意义也就不会回调了，下次position滚动会当前屏幕以内的时候同样会调用onBindViewHolder()方法刷新数据了。其他的方法也是同样的道理。

    其它：notifyItemRangeChanged(int positionStart, int itemCount)......（包括插入、移动、删除、批量操作）

    当列表数据变更时，调用notifyDataSetChanged()是最省事的。无需关心变更的细节，但这样做也是最昂贵的。

### 观察者模式

1. Adapter.notifyDataSetChanged() 将刷新操作委托给 AdapterDataObservable

    ``` java
    public abstract static class Adapter<VH extends ViewHolder> {
        private final AdapterDataObservable mObservable = new AdapterDataObservable();
        public final void notifyDataSetChanged() {
            mObservable.notifyChanged();
        }
    }
    ```

2. AdapterDataObservable 是 RecyclerView 的静态内部类，它继承自Observable：

    ``` java
    static class AdapterDataObservable extends Observable<AdapterDataObserver> {
        public void notifyChanged() {
            // 遍历所有观察者并委托之
            for (int i = mObservers.size() - 1; i >= 0; i--) {
                mObservers.get(i).onChanged();
            }
        }
        ...
    }
    ```

3. Adapter 数据的观察者的注册时间：

    ``` java
    public void setAdapter(@Nullable Adapter adapter) {
        setLayoutFrozen(false);
        setAdapterInternal(adapter, false, true);
        processDataSetCompletelyChanged(false);
        requestLayout();
    }

    // 为 RecyclerView 设置 Adapter
    private void setAdapterInternal(@Nullable Adapter adapter, boolean compatibleWithPrevious, boolean removeAndRecycleViews) {
        if (mAdapter != null) {
            // 移除之前的观察者
            mAdapter.unregisterAdapterDataObserver(mObserver);
            mAdapter.onDetachedFromRecyclerView(this);
        }
        ...
        final Adapter oldAdapter = mAdapter;
        mAdapter = adapter;
        if (adapter != null) {
            // 注册新的观察者
            adapter.registerAdapterDataObserver(mObserver);
            adapter.onAttachedToRecyclerView(this);
        }
        ...
    }
    public abstract static class Adapter<VH extends ViewHolder> {
        // 注册观察者
        public void registerAdapterDataObserver(@NonNull AdapterDataObserver observer) {
            mObservable.registerObserver(observer);
        }
    }
    ```

4. Observable是一个抽象的可被观察者：

    ``` java
    // 被观察者, 泛型表示观察者的类型
    public abstract class Observable<T> {
        // 观察者列表
        protected final ArrayList<T> mObservers = new ArrayList<T>();
        // 注册观察者
        public void registerObserver(T observer) {
            ...
            mObservers.add(observer);
            ...
        }
        // 注销观察者
        public void unregisterObserver(T observer) {
            ...
            mObservers.remove(index);
            ...
        }
        // 移除所有观察者
        public void unregisterAll() {
            ...
            mObservers.clear();
            ...
        }
    }
    ```

5. 在为 RecyclerView 绑定 Adapter 的时候，一个观察者实例RecyclerViewDataObserver被注册了：

    ``` java
    private class RecyclerViewDataObserver extends AdapterDataObserver {
        RecyclerViewDataObserver() {}
        @Override
        public void onChanged() {
            assertNotInLayoutOrScroll(null);
            mState.mStructureChanged = true;
            processDataSetCompletelyChanged(true);
            if (!mAdapterHelper.hasPendingUpdates()) {
                requestLayout();
            }
        }
        ...
    }
    ```

### onChange()更新前的全量无效化

1. RecyclerView 遍历了当前所有已经被加载的表项，并为其 ViewHolder 添加 FLAG_UPDATE 和 FLAT_INVALID 标志位。

    ``` java
    void processDataSetCompletelyChanged(boolean dispatchItemsChanged) {
        mDispatchItemsChangedEvent |= dispatchItemsChanged;
        mDataSetHasChangedAfterLayout = true;
        // 将当前所有表项无效化
        markKnownViewsInvalid();
    }
    void markKnownViewsInvalid() {
        // 遍历列表所有表项
        final int childCount = mChildHelper.getUnfilteredChildCount();
        for (int i = 0; i < childCount; i++) {
            final ViewHolder holder = getChildViewHolderInt(mChildHelper.getUnfilteredChildAt(i));
            // 列表中每个表项的 ViewHolder 添加 FLAG_UPDATE 和 FLAG_INVALID 标志位
            if (holder != null && !holder.shouldIgnore()) {
                holder.addFlags(ViewHolder.FLAG_UPDATE | ViewHolder.FLAG_INVALID);
            }
        }
        markItemDecorInsetsDirty();
        // 将缓存中表项无效化
        mRecycler.markKnownViewsInvalid();
    }
    ```

2. RecyclerView 将所有离屏缓存中的 ViewHolder 也都做了无效化处理，回收到缓存池。

    ``` java
    public final class Recycler {
        void markKnownViewsInvalid() {
            // 遍历所有离屏缓存
            final int cachedCount = mCachedViews.size();
            for (int i = 0; i < cachedCount; i++) {
                final ViewHolder holder = mCachedViews.get(i);
                // 将每个离屏缓存中的 ViewHolder 也添加 FLAG_UPDATE 和 FLAG_INVALID 标志位
                if (holder != null) {
                    holder.addFlags(ViewHolder.FLAG_UPDATE | ViewHolder.FLAG_INVALID);
                    holder.addChangePayload(null);
                }
            }
            if (mAdapter == null || !mAdapter.hasStableIds()) {
                // 将离屏缓存中的 ViewHolder 存入缓存池
                recycleAndClearCachedViews();
            }
        }
    }
    ```

### 真正的刷新

在将一切都无效化后，调用了View.requestLayout()，即请求重新布局，该请求会不断地向父控件传递

``` java
public class View {
    public void requestLayout() {
        ...
        // 添加两个标志位
        mPrivateFlags |= PFLAG_FORCE_LAYOUT;
        mPrivateFlags |= PFLAG_INVALIDATED;
        // 向父控件传递重绘请求
        if (mParent != null && !mParent.isLayoutRequested()) {
            mParent.requestLayout();
        }
        ...
    }
}
```

列表的重新布局意味着重新布局其中的每一个表项，体现在代码上即是LinearLayoutManager.onLayoutChildren()（holder.needsUpdate() || holder.isInvalid()）

``` java
public class LinearLayoutManager {
    public void onLayoutChildren(RecyclerView.Recycler recycler, RecyclerView.State state) {
        ...
        fill();
}
```

- 总结

1. RecyclerView 使用观察者模式刷新自己，刷新即是通知所有的观察者。

2. 观察者是RecyclerViewDataObserver（抽象为AdapterDataObserver），它们维护在RecyclerView的静态内部类AdapterDataObservable中，储存的数据结构是ArrayList<T>。

3. RecyclerView 在真正刷新列表之前，使用processDataSetCompletelyChanged(true);将一切都无效化了，包括当前所有被填充表项及离屏缓存中的 ViewHolder 实例。无效化体现在代码上即是为 ViewHolder 添加 FLAG_UPDATE 和 FLAG_INVALID 标志位。

    ``` java
    holder.addFlags(ViewHolder.FLAG_UPDATE | ViewHolder.FLAG_INVALID);
    ```

4. RecyclerView.requestLayout();是驱动列表刷新的源头，该方法会从根视图自顶向下进行重绘。RecyclerView的重绘表现为重新布局所有表项。

5. RecyclerView重新布局所有表项：先回收现有表项到缓存池，再重新填充他们。因为回收时ViewHolder都被添加了无效化的两个标志位，所以重绘时即使数据没变也需要重新绑定数据，导致资源消耗比较昂贵。
