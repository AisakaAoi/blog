---
title: Android-RecyclerView-正确获取item位置
categories:
  - 🌙逢坂杂谈与搬运
  - ⭐一些技术
abbrlink: '190959e8'
date: 2021-09-13 16:05:32
tags:
---

## RecyclerView中正确获取item位置

上次走读仕宝哥的Contact us代码，学到了一招ConcatAdapter，稍微查了学习一下做个总结：

使用RecyclerView时，总需要知道其ItemView的位置来实现各种需求：设置点击事件、滚动列表至指定的Item位置

为此RecyclerView提供给我们获取位置的API：

1. onBindViewHolder(ViewHolder holder, int position)

2. getAdapterPosition

3. getBindingAdapterPosition

4. getAbsoluteAdapterPosition

5. getLayoutPosition

<!--more-->

### onBindViewHolder 中的 position 参数

通常我们会在onBindViewHolder中通过postion参数绑定 data 和 View

``` java
@Override
public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
    ((InnerHolder) holder).setData(mGalleryData.get(position), position);
}
```

但是如果在这里使用position参数来处理点击事件就会有点不合适了，比如这样子

``` java
itemView.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        if (mOnItemClickListener != null) {
            mOnItemClickListener.onItemClick(mGalleryData.get(mPosition), mPosition);
        }
    }
});
```

然后我们加入一个按钮，移除列表的第一个数据

``` java
public removeFirstItem(){
    list.removeAt(0);
    notifyItemRemoved(0);
}
```

这时候就会出现以下效果：

{% asset_img 1.gif %}

按照预期，应该是点击哪个位置，就弹出那个位置的position的toast，可是当我们调用removeFirstItem方法移除列表的第一个item后，就会出现 item 和 position 对不上号的情况（点击了postion：1弹出的toast显示点击了：2），**这就是在onBindViewHolder中直接使用position参数设置点击事件可能引发的问题**。

原因：使用notifyItem*()此类方法来删除/添加/更改RecyclerView的数据中的任何一条数据时，RecyclerView并不会调用所有Item的onBindViewHolder方法更新item的位置，它只会更新notifyItem*()的位置，所以导致了显示的数据和真实的数据 Position 对应不上的问题。

为此，源码注释给出了解释和解决方案：使用getAdapterPosition

``` markdown
* Note that unlike {@link android.widget.ListView}, RecyclerView will not call this method
* again if the position of the item changes in the data set unless the item itself is
* invalidated or the new position cannot be determined. For this reason, you should only
* use the <code>position</code> parameter while acquiring the related data item inside
* this method and should not keep a copy of it. If you need the position of an item later
* on (e.g. in a click listener), use {@link ViewHolder#getBindingAdapterPosition()} which
* will have the updated adapter position.
```

### getAdapterPosition

ViewHolder为我们提供了 getAdapterPosition 方法来获取 ViewHolder 的位置。该方法总是返回 ViewHolder 最新的位置，也就意味着使用该方法，即使调用notifyItem*()此类方法来删除/添加/更改 RecyclerView 的数据，该方法返回的位置也能确保获取的Position是正确的。

但getAdapterPosition()被废弃了，原因是在 Adapter 嵌套Adapter 的情况下会带来歧义，推荐使用 getBindingAdapterPosition 或者 getAbsoluteAdapterPosition 这两个方法。

``` markdown
/**
 * @return {@link #getBindingAdapterPosition()}
 * @deprecated This method is confusing when adapters nest other adapters.
 * If you are calling this in the context of an Adapter, you probably want to call
 * {@link #getBindingAdapterPosition()} or if you want the position as {@link RecyclerView}
 * sees it, you should call {@link #getAbsoluteAdapterPosition()}.
 */
```

对于Android来说，复杂的Feed流页面，我们基本都是通过RecyclerView的多样式布局来实现，通过重写Adapter的getItemViewType来区分不同的样式，实现不同的UI逻辑，长久以来一直如此。

这种长久以来的写法，最大的问题就是将不同样式类型的布局耦合在了同一个Adapter中，随着业务的迭代，这个耦合的Adapter很有可能变得异常臃肿，而且这种写法要时刻注意数据的处理要区分ViewType，给日后的维护带来极大的挑战。

谷歌大概是看到了开发者面对这种复杂页面开发和维护时脸上的痛苦面具，所以他们推出了ConcatAdapter这个玩意，简单来说，它就像一个容器，里面可以添加多个Adapter，然后将ConcatAdapter设置为RecyclerView的Adapter，从而轻松实现多样式布局的效果。这就是谷歌官网所写的 Adapter 嵌套 Adapter情况：ConcatAdapter 里可能会包含了多个开发者写的Adapter。

这种情况下，我们如果继续调用getAdapterPosition就会引发歧义了，因为程序可能并不知道你想要的是ViewHolder的**相对位置**，还是**绝对位置**。

### 相对位置与绝对位置，getBindindAdapterPosition 与 getAbsoluteAdapterPosition

{% asset_img 2.webp %}

官方提供的两个方法getBindingAdapterPostion与getAbsoluteAdapterPosition就是用来获取ViewHolder的相对位置和绝对位置的。

getBindingAdapterPosition将会返回该ViewHolder相对于它绑定的Adapter中的位置，即相对位置。

getAbsoluteAdapterPosition将会返回该ViewHolder相对于RecyclerView的位置，即绝对位置。

回到开头提到的两种典型的RecyclerView中使用Position的场景：

设置点击事件 & 记录，我们往往使用getBindingAdapterPostion获取ViewHolder对应的数据项，完成点击操作。

操作RecyclerView的滚动状态，我们应该使用getAbsoluteAdapterPosition来操纵RecyclerView的滚动。

不过，如果项目完全没有使用ConcatAdapter，那getBindingAdapterPostion和getAbsoluteAdapterPosition没有任何区别，不过仍推荐按照不同的使用场景选用不同的方法获取适合的位置参数，毕竟以后使用ConcatAdapter 就方便很多了。

### getLayoutPosition

顾名思义，就是获取该ViewHolder在实际布局中的位置。

RecyclerView使用LayoutManager来管理数据集的现实。当开发者调用notifyData*()等方法通知RecyclerView刷新UI时，出于性能的考虑，RecyclerView的UI并不会立刻刷新，和Data保持一致，而是通过LayoutManager惰性更新相关布局——这个过程伴随着时间上的等待，通常情况下，这个等待时间小于16ms。所以，从感官上讲，getLayoutPosition与getAbsoluteAdapterPosition十分相似：getAbsoluteAdapterPosition返回的是该ViewHolder相对于RecyclerView的绝对位置，而getLayoutPosition返回的是该ViewHolder相对于RecyclerView实际布局的绝对位置。

简单来说，就是adapter和layout的位置会有时间差(通常情况下<16ms), 如果你改变了Adapter的数据然后刷新视图, layout需要过一段时间才会更新视图, 在这段时间里面, 这两个方法返回的position会不一样，即在notifyDataSetChanged之后并不能马上获取Adapter中的position，要等布局结束之后才能获取到。

对于Layout的position，在notifyItemInserted之后，Layout不能马上获取到新的position，因为布局还没更新（需要<16ms的时间刷新视图），所以只能获取到旧的，但是Adapter中的position就可以马上获取到最新的position。

所以，对于上面的点击事件的场景，我们在获取用户点击位置的时候，使用getLayoutPosition可能效果更好，这样就能确保用户点击的始终是他看到的那个数据（消除16ms带来的时间差问题）
