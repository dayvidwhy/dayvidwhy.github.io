---
layout: post
title:  "Short Circuit Vue Computed"
date:   2021-08-30 10:20:00 +1000
categories: ['vue', 'reactivity', 'experiment']
permalink: short-circuit-vue-computed
---
Two counts are stored in the example below, with the total displayed being the sum of the two. When you click on the left count, the total count increases to 2, as you would expect, but subsequent presses on the left count stop the total count from incrementing, unless you click the right count. Strangely if you start by pressing the right count, it doesn't incremenent at all, until you click on the left count.

<iframe src="https://codesandbox.io/embed/vue-dependency-collection-5iokz?fontsize=14&hidenavigation=1&theme=dark"
     style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;"
     title="Vue dependency collection"
     allow="accelerometer; ambient-light-sensor; camera; encrypted-media; geolocation; gyroscope; hid; microphone; midi; payment; usb; vr; xr-spatial-tracking"
     sandbox="allow-forms allow-modals allow-popups allow-presentation allow-same-origin allow-scripts"
   ></iframe>

# Short circuit expressions
In JavaScript we can create boolean comparisons between variables using `||` and `&&` to create more complex comparisons. What I always find interesting, is the short hand performance quirk related to the logical and, `&&`.

```js
const falsy = false;
const truthy = () => {
  console.log("Inside our truthy function");
  return true;
};

if (falsy && truthy()) {
  // never reached, and truthy() does not run
}
```

The if statement won't resolve to true and we're doing a logical `&&` where the first value is false, so the result has to be false. The performance quirk with JavaScript is that since our if statement _can't_ be true, the second expression is not considered or executed.

# How Vue knows what is accessed in computed properties
An [interesting response](https://forum.vuejs.org/t/how-do-computed-properties-know-how-to-change/24140/6) to similar question posted online and made a large amount of sense. Vue wraps properties with its `getter` and `setter` functions, so if you try accessing our values in the above examples computed property, Vue notices they're being accessed, and adds them to its internal system as dependents of the total count.

Since the short circuit logical comparison means the second value will not be considered at all it starts making sense why the behaviour is how it is in the abobe example.

# Breaking down the flow
In the example above we are using a Vue watcher to watch `totalCount`, which is a computed result of `countLeft && countRight`. Initially `coundLeft` is 0, and `countRight` is 1, so as we can expect, clicking on the right count initially does not cause any change in the total count.

```js
// leftCount && rightCount
0 && 1 // 0
// then when we increment leftCount
1 && 1 // 1
// result changes, watcher notices
```

Once we click on the left count, the computed property runs again, and this time since the left count is a truthy value, the right count is collected as a dependency. Furthermore, clicking the right count further increments the total. But then you will notice that the left count increments stop increasing the total.

At this point clicking on the left count increments its count, but you have to click on the right count to get the total to update each time. Clicking the left count still triggers the computed to rerun as you would expect, but the watcher does not run unless the right count changes.

```js
// leftCount && rightCount
// further incrementing the leftCount
1 && 1 // 1
2 && 1 // 1
3 && 1 // 1
// result does not change, watcher does not notice

3 && 2 // 2
// but incrementing the right count, value changes, watcher notices
```

The count updates when incrementing the right count due to the nature of the watcher observing the logical comparison of both counts. Since it is doing `countLeft && countRight`, the result once `countLeft` is not 0, will be `countRight`. When two numbers are compared the right hand number is the result of the comparison.

# Furhter thoughts
This example is solved by simply changing the computed `totalCount` to be the sum of both counts, over the logical `&&`.

```js
watch: {
  totalCount() {
    // this.totalValue = this.countLeft && this.countRight;
    this.totalValue = this.countLeft + this.countRight;
  }
}
```

But it does serve to show an interesting point where care needs to be taken with what logic is placed within Vue computed properties, because if Vue does not notice a dependency, it will not update the computed property.