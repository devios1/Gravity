#Gravity
An easy to learn XML-based layout description language for iOS powered by Auto Layout.

**tl;dr** It's kind of like HTML for native layouts, and is an order of magnitude easier to use than raw Auto Layout.

Gravity was forged on the radical idea that **layout doesn't have to be complicated**.

##Sample
Suppose you wanted to construct the following simple layout (everything inside the bubble):

![Sample](img/Sample.png)

In Auto Layout, your job is to examine each edge of each view, figuring out which other view edges each one should bind to and at what constraint priorities, what each view's content compression resistance and content hugging priorities are (if applicable), and whether or not you have enough constraints to fully satisfy both axes, or have too many and have an ambiguous layout.

With Gravity, on the other hand, we approach things in a much different way. Instead of tying edges to each other with constraints in an attempt to *implement* a desired idea in mind, we think more about how the whole layout is arranged from a higher level and simply communicate this to Gravity. We do this by breaking a layout down into a series of embedded horizontal (`<H>`) and vertical (`<V>`) *stacks*. Looking at the above image, we can see that the Order button is clearly to the right of everything else, and we simply tell Gravity as much. This is our first division and it is horizontal. Everything to the left of the Order button can be seen as being stacked vertically, with the two directions buttons that form the bottom row themselves stacked horizontally.

Here's how you say that in gravity:

```xml
<H gravity="middle" color="#fff">
	<V gravity="top left">
		<UILabel id="titleLabel" text="1188 W Georgia St" maxWidth="200" font="System Semibold 16" textColor="#ffffff" wrap="true"/>
		<UILabel id="hoursLabel" text="Open today: 6am - 11pm" font="System 14.0" textColor="#ffffff7f"/>
		<H gravity="middle" spacing="0" height="28" color="#ffffff">
			<UIButton id="carButton" action="carButtonPressed:" backgroundColor="#0076FF" cornerRadius="4" minWidth="80">
				<H alignment="center" userInteractionEnabled="false">
					<UIImageView width="22" height="22" image="Directions-Car"/>
					<UILabel text="12 mins" font="System Bold 16.0"/>
				</H>
			</UIButton>
			<UIButton id="walkButton" backgroundColor="#0076FF" cornerRadius="4">
				<H alignment="center" userInteractionEnabled="false">
					<UIImageView width="22" height="22" image="Directions-Walk"/>
					<UILabel text="22 mins" font="System Bold 16.0"/>
				</H>
			</UIButton>
		</H>
	</V>
	<UIView>
		<UIButton width="64" gravity="center" backgroundColor="#ffffff00">
			<V>
				<UIImageView image="chevron-right-bold"/>
				<UILabel text="Order" color="#fff"/>
			</V>
		</UIButton>
	</UIView>
</H>
```

Gravity aims to reduce the mental burden of going from a layout you have *in mind* to an actual functioning application in code. It accomplishes this by representing your layout in a much more natural and intuitive manner than pure Auto Layout. If it feels strange looking at code when you're used to seeing a visual representation, the change can be jarring. But give it five minutes. Gravity is a markup language. Think of it as being closer to a spoken language than a programming language. You are describing things at a higher conceptual level than raw constraints, speaking in terms of order and arrangement moreso than pixel offsets.

##Background
In my thirty-five years of existence in this universe, I have encountered few things as brutally frustrating as Apple's Auto Layout engine. For a company that prides itself in the intuitiveness and ease of use of their software, Auto Layout represents a complete 180° on that stance, instead favouring bizarre and unnatural complexity over simplicity of design. The result is a beast of a system that takes many long hours to become even remotely proficient in.

Auto Layout has its apologists, and while there's no arguing it's a powerful system, the fact remains that if you've ever had to work with Auto Layout at some point in your career, you're all but guaranteed to have had a frustrating experience. Trust me, you're not alone.

Auto layout tends to work well in two scenarios:

1. Extremely simple layouts, and
2. Extremely complex layouts.

It fails though, utterly in my opinion, at handling 99% of the layouts typical in modern software: those that need slightly more power than the absolute basic defaults, but which are not so mind-numbingly complex as to require the type of prioritized constraint engine Auto Layout is based upon.

Here's my background: I've always been a Mac guy, but I dabbled with .NET for a while in the mid 2000's. During this time I discovered (and eventually fell quite in love with) WPF, a.k.a. Windows Presentation Foundation. To me, WPF represented a quantum leap forward in the natural expressibility of the very *language* of expressing visual layouts, using a simple hierarchical structure based on XML they called XAML. (Horrible, horrible names. Apparently WPF was originally called Avalon. And they changed it to WPF. Like WPF were they thinking. I digress.)

After leaving the Windows world and coming back to Apple by means of the iOS platform, I was utterly dismayed at the mediocre layout tools available to me: at first it was Interface Builder with springs and struts, which was familiar to me from my classic Mac OS programming days. While the springs and struts model was a breeze to understand and worked fairly well for very simple interfaces, it was ultimately very limited in what it could express. It wasn't until Apple released their "next big thing" in layout, though, that things got truly bad.

Auto Layout, they called it. Ha! As if there is anything "auto" about it! It is, in fact, painstakingly manual. Now, instead of simply telling the computer which edges of an element should expand and which remain fixed in place, you have to tie individual edges of elements to each other, and chain these bindings together in a balancing act of constraint priorities, arranged in precisely the right manner, for fear of not supplying all the required constraints, or supplying too many and having ambiguous or conflicting constraints, all the while having many unnatural things to worry about: (constraint priorities, content hugging, compression resistance, user constraints, system constraints, intrinsic size, implicitly generated constraints, placeholder constraints, etc., etc.). Things went from simple but limited to insanely complex overnight.

Anyway if you've made it this far I'm probably preaching to the choir.

The *good* news is that Auto Layout is quite powerful enough to act as the foundation for another much simpler layer built on top of it. Enter Gravity.

Why "Gravity"?

Well, gravity is simple. It's a universal law: things attract. Gravity is the universe's way of optimizing space, just like your interface will size to fit its contents by default, and will automatically look good and behave like you want, and more importantly, how your users expect.

Gravity is consistent. It doesn't behave in one way here and another way somewhere else (at least as far as we know!). Consistency and *intuitiveness* are hugely important in a framework. I don't expect you to learn the whole thing up front, I expect you to figure it out as you go. Gravity is designed to be highly figureoutable.

Go ahead, look at any user interface, be it a web page or in an app. Looking at it, you already have a good idea of which elements should expand or shrink, and which elements should collapse before other elements. It's usually pretty obvious. Gravity aims to turn that intuitive knowledge into a functioning UI with as little work as possible.

Gravity is inspired on the surface by XAML, but is a much simplified take on it. You design your layout as a tree: everything has its place in the hierarchy, so you don't need to worry about explicitly tying things together, and the resultant interface is generated deterministically with all of the proper layout constraints in place. You get all the benefits of Auto Layout without the burden of having to touch it yourself. (Although you *can* touch it if you want to. It's all still there and easy to get to. Gravity isn't a black box—er… hole?)

Gravity is really a layout engine for programmers who prefer the precision and control of a code file over loosey-goosey mousework. Unlike Interface Builder, which presents you with a visualization of your software and requires you to build and tweak that interface with your mouse, Gravity lets you build and tweak your interface *textually*, just like editing source code. It is mathematically precise and because it manages all of the layout constraints for you, has far fewer points of potential failure than traditional Auto Layout. Gravity aims to be a truly solid foundation for your app's interface.

Calling Gravity a "layout engine" is a bit of a stretch. It's more of a high-level layout *language*. Auto Layout is still the true engine powering Gravity. Gravity just gives you a much simpler way to specify your interface, and Auto Layout takes care of the heavy lifting behind the scenes. Gravity is the curtain that hides the great and powerful Oz.

##The Philosophy
Constructing an interface is a way of communicating. It is a way for the developer of an application to communicate relevant contextual information to the user. It shouldn't be something that is hard or takes painstaking work. It should be as natural as language: as thoughts arranged in such a way as to be understood.

Gravity takes most of the *work* out of creating a layout and lets you get back to being creative.

##The Basics
Gravity is, at the simplest, an XML representation of a native layout. Its elements are view classes and its attributes generally correspond to properties of those classes. Some attributes like `gravity`, `color`, `width`, `height`, etc. have special meaning and don't correspond directly to native properties. Gravity aims to keep syntax simple and thus employs many special helper handlers for attributes when mapping directly to properties doesn't work. For example, UIButton does not have a native "title" property, yet in Gravity you can say `<UIButton title="Press Me"/>`. This is because UIButton.title is implemented internally as UIButton.setTitle(_, forState:).

But even better than doing that is the fact that you can embed views in any other view, including UIButtons. So you can actually lay out your button's contents using Gravity too! (Note: There are currently limitations in doing this for buttons, namely that embedded views do not presently respect the button's control state and will not react to presses.)

In Gravity, you arrange your views by using a combination of stacking and layering. Stacking is fundamental while layering is generally more optional for more complex layouts.

###Stacking
Stacking can take place either horizontally (`<H>`) or vertically or (`<V>`) in a **stack view**. A stack view contains an arbitrary number of child views, each of which will be stacked in a line along the axis of the stack view.

###Layering
Layers in Gravity are analogous to layers in drawing and paint programs: unlike stack views which arrange their subviews in a line horizontally or vertically, layering arranges views *inwards* and *outwards*—that is, along the Z axis.

###Gravity
Aligning things in Gravity is done with… gravity! Not just a cool name, it's also a key concept in the framework. Gravity is a scoped property that determines the direction elements are attracted to in a layout.

Gravity does not have a corresponding concept in Auto Layout because it comes about from the fact that Gravity is hierarchical (in fact much of the framework's power comes from this fact). Elements inherit their gravity from their parent element in the tree. Thus, changing the gravity for an element affects that element and all elements inside it. You can change the direction of gravity at any point in the tree.

Gravity is split into two axes: horizontal and vertical, and each axis can have one of three possible values. For example, the horizontal gravity can be one of Left, Center, and Right, while the vertical gravity can be one of Top, Middle, and Bottom. Remember, Center means horizontal center while Middle means vertical center.

You can specify one or both axes of gravity at a time. If you omit an axis, that axis will continue to inherit its value from its parent element. Separate multiple gravity values with a space. So, to dock a view to the top-right corner of its parent, set `gravity="top right"`. To center an element horizontally without affecting its vertical gravity, simply set `gravity="center"`. Remember, changing the gravity affects all child elements too, so if you want the things *inside* the view to dock to a different edge, don't forget to adjust their gravity as well.

Note: You can also set native properties like the `alignment` of a stack view or the `textAlignment` of a label directly to avoid changing the gravity for an entire subtree.

###Growing and Shrinking
In Auto Layout, you control how elements expand and contract by a combination of **content hugging priority** and **content compression resistance priority**, each of which (being a priority) takes a value between 0 and 1000.

In Gravity, things are much simpler to wrap your head around. By default, all views shrink to their smallest natural size that displays all of their content. If you want a view to grow to take up all of the available space, set its `width="fill"`. A view will only ever grow up to the next explicitly-sized view (width, maxWidth, etc.).

To control shrinking, you simply set a shrinking order in which elements in a container should collapse in sequence. Usually you will only need to set a couple of these, because the rest can be inferred. Set the order in which the elements should shrink when there is not enough room for them all to fit. You can also use negative numbers to count from last place, so that `shrinks="-1"` would be the last element to shrink. You can number as many or as few views as you want and the rest will be inferred (potentially arbitrarily).

Note that if there is a view set to fill and there is presently more space available than required to display all of the content, the over-sized filled view will take precedence in shrinking order, until it reaches its natural intrinsic size, at which point the shrinking order will come into effect.

Like so:

```xml
<H>
	<UILabel text="I am just a label:" shrinks="1"/>
	<UILabel text="I am important content." shrinks="-2"/>
	<UIImage id="statusIcon" image="exclamation-22" shrinks="-1"/>
</H>
```

Given the above layout, it's easy to see that the label will be the first thing to shrink when space gets tight, and the status icon (which is apparently quite important) will be the last thing to go. If there is extra space, it will all go to the middle content label.

Perhaps you want the label to shrink, but only to a point. If you set a minWidth on the label, that will have a higher constraint priority and block the element from shrinking any further.

Unfortunately, I haven't figured out how to get UIStackView to grow or shrink multiple elements equally together. This was really the intended design, but unfortunately doesn't appear to be possible just yet and the stack view seems to always just choose the last element.

###Edge Binding
Gravity accomplishes view containment by means of edge binding at differing priorities. Most views are bound on all edges to their parent by at least some priority. Gravity sets these priorities based on the configuration of your layout and the information you provide for how views should resize; for example, whether they are filled along an axis, have an explicit size or are constrained to a max/min size.

###Encapsulation
Encapsulation couldn't be simpler in Gravity. To create a reusable control or layout template, all you need to do is author that layout as its own gravity file. You can then reference it in another layout by creating a node with the same name as that file. That's literally all you have to do. There's no registering, no linking, no outlets.

But it gets even better. Give an element in your sub-layout an id, and you will be able to configure it from the parent referencing layout using attribute dot notation!

**FormRow.xml**
```xml
<H gravity="middle">
	<UILabel id="titleLabel" gravity="left" color="#666" width="col1" minWidth="80" text="Title"/>
	<UILabel id="valueLabel" text="Value"/>
</H>
```

**Main.xml**
```xml
<UIView backgroundColor="#0ff">
	<V width="300" gravity="top left">
		<FormRow titleLabel.text="Name:" valueLabel.text="George McFly" />
		<FormRow titleLabel.text="Address:" valueLabel.text="Hill Valley, CA" />
		<FormRow titleLabel.text="Phone:" valueLabel.text="+1 (604) 555-1234" />
		<FormRow titleLabel.text="Email:" test.label.text="captain.stardust@gmail.com" />
	</V>
</UIView>
```

This is fully recursive too, so you can encapsulate as many levels deep as you want, and also access as deep as you want with multiple dots:

```xml
<ProfileView addressView.streetLabel.text="8 James St"/>
```

However, a much better way to do something like an encapsulated profile view is with…

###Models
With models you are truly offloading the work of displaying  in an object-oriented fashion.

Important: If you are using Gravity with Swift, data binding currently only works with `dynamic` NSObject properties. To ensure that your model objects can be read and observed by Gravity properly, make sure your model class derives from NSObject at some point and mark all observable properties with the `dynamic` keyword:

```swift
class MyObjectToObserve: NSObject {
    dynamic var myDate = NSDate()
    func updateDate() {
        myDate = NSDate()
    }
}
```

*Unfortunately, and until Swift introduces some form of native support for property observation, you are stuck with this requirement. This is truly the biggest limitation in Swift affecting Gravity. It's 2016. We need observable properties, Apple! If you're using Gravity from Objective-C, fortunately all of your objects are already NSObjects, so this doesn't affect you.*

There is a certain symmetry between models and encapsulation, and in fact two distinct "directions" of control you can choose for your layout: parent-controlled or self-controlled. Think of a parent-controlled view as a general-purpose reusable control (its purpose is determined by its parent) whereas a self-controlled view knows exactly what it will be viewing and how to get that information from its associated model object (in this case, the only "control" the parent has is to actually assign the model). Think of a self-controlled view such as this as a black box, whereas a parent-controlled view is a white box (metaphorically speaking) whose internals are exposed.

In general, you will use parent-controlled views for simpler, lower-level reusable components (such as a table row) while self-controlled views are viewers for specific data types, and therefore occupy a higher conceptual level. In many cases, your self-controlled views will be built up of lower-level parent-controlled views. Very rarely will it ever be the other way around.

###Controllers
The controller is there to do anything that you can't do in your gravity file itself. Generally speaking, it does the "thinking"—any logic that you need to do in code, and generally corresponds one-to-one with the view file. You supply this and it can be any NSObject, however there will typically be exactly one class that will naturally represent the controller, depending on the purpose of the layout. In most cases it will be a descendent of UIView or UIViewController.

How the controller is treated is really up to each plugin or supported class. For example, the UIButton's class support will bind action="selector:" attributes to selectors in your controller, whatever it may be.

###Attribute Nodes
Gravity supports a special syntax I call **attribute nodes** (property element syntax in XAML) which allows you to define attributes as sub-nodes, rather than strings. This gives you much more flexibility than string notation when you need it, and works perfectly for assigning embedded layout templates to attributes.

XML's syntax only allows string values for attributes, which works in a great many cases, especially when you add string converters to the mix, but there are times when having a single string just isn't enough to represent the configuration of an object. For these situations, we have attribute nodes.

Attribute nodes are specified using the parent element's name followed by a dot followed by the property name. Everything following the parent element's name is treated as an attribute on the parent element. You can still access child document identifiers by appending further dot components.

```xml
<ParentElement inlineAttribute="inlineValue">
	<ParentElement.attributeNode>
		<!-- Everything in here is considered the value of the "attributeNode" attribute on ParentElement. -->
	</ParentElement.attributeNode>
	
	<!-- ParentElement's child nodes (if any) would go here as per usual. -->
</ParentElement>
```

Note that attribute nodes aren't limited to representing layouts. You can specify any arbitrary XML inside an attribute node and it will be delivered to the plugin or supported class as a `GravityNode` (as all attribute values are), which can be interpreted as desired.

###Scoped Attributes
A scoped attribute is an attribute that affects the node it is applied to and all child nodes of that node, until it is overridden. Note that scoped attributes do not traverse document boundaries, so if you embed another document inside your layout, attributes like gravity and color will not extend into that document.

Instead, if you want to customize the appearance of elements within your embedded document, you want to use **styles**. [Not yet implemented]

##Benefits
###True Native UI (Fast!)
Gravity is a pure Auto Layout framework. It doesn't make compromises when it comes to supporting different platforms and produces blistering fast, truly native layouts using only Auto Layout. It's just the way you instantiate your layouts that has changed, not the final result.

Gravity is also super lightweight. Aside from the tiny DOM (which simply gives you object-oriented access to the contents of your XML files) and whatever minimal overhead each plugin uses (the built-in ones are also very lightweight), there is very little memory overhead. And once your view is actually constructed, Gravity steps aside and lets Auto Layout take over, so there's no performance hit whatsoever. Plus, Gravity is almost entirely implemented in Swift, which compiles to fast native code.

In short, Gravity is fast. Very fast. But it is also very young and there is still much to be implemented. Load times are the biggest danger point because of all of the plugin processing. I will focus on design for the immediate future and pursue optimization when the core stabilizes.

###Create Perfect Interfaces
Gravity is mathematically precise. Never accidentally misdrag an edge or element again. With Gravity, what you *write* is what you get. (Hey does that mean Gravity is **WYWIWYG**? Yeah that's probably never going to catch on…)

###No More Ambiguous Layouts
In theory, any possible layout you can construct with Gravity will be guaranteed to be correct as far as Auto Layout is concerned. No missing constraints, no ambiguous constraints.

The deterministic nature of the hierarchy that powers Gravity answers any and all ambiguities Auto Layout may be worried about. Ambiguous and missing constraints just aren't something you have to think about when using Gravity.

###Real MVC
Gravity is a true realization of the Model-View-Controller paradigm. There are probably few who would argue in favour of Apple's implementation (which many jokingly refer to as "Massive View Controller"). This is because of a few mistakes Apple made, in my humble opinion:

1. They made encapsulation too difficult (or at best too tedious)
2. They didn't split the view from the controller properly (UIViewController does both view and controller related things)
3. Use of the delegate pattern instead of a publisher-subscriber model for events (which results in exclusively binding child objects to the view controller)
4. And generally failing to follow object-oriented principles (UITableView, UICollectionView)

All of these contribute to the ViewController in Apple's implementation becoming a monolithic "catch-all" class that essentially does the work of many things.

An example: If I want to add a sub-element to my interface to display information in a table, I would drag a UITableView into my XIB or Storyboard, bind its delegate to my controller, and implement a handful of UITableView *delegate* methods on my controller. The methods we are adding to our view controller do not pertain to the objective role of that class, they pertain to the function of a *child* of that class. This means that the more children you have to manage in your class, the bigger that class is itself going to get, managing all of those children's delegate methods. Not a good design.

In Gravity, the view talks directly to the model (or if you prefer a looser separation of concerns, a view-model) and views can be broken down into as many levels of embedded views as you like. There's often no controller even involved. Your XML file represents your view. The model, as always, is independent and has no knowledge of the view or the controller, but through its documented interface exposes the properties and methods that will ultimately be accessed by the view, by means of property dot-notation and data binding.

This establishes the view's connection to the model. Notice the controller isn't even involved yet. In many cases in Gravity a controller is actually not needed, believe it or not. Unlike Apple's model, where the view controller is fundamental, in Gravity it's the least important citizen. In Gravity, the controller is there to essentially do anything that you can't just do in your gravity file itself. So any arbitrary logic (i.e. code) goes into the controller. The controller is the thinking part. The model and the view are just the data and the displaying of that data, respectively.

In Gravity, to add a table to your view you add a UITableView node to your layout and provide it with a *row template*, which is itself a view hierarchy that is either written directly into the document, or a reference to an encapsulated child layout. Each instantiation of a row from the template will have a different data context (model object) for each element of the table's data source, and will render itself accordingly. And we *still* don't need a controller for any of this!

###Super Extensibility
Gravity was designed with extensibility in mind from the get-go. I knew that there was no way I could personally write every possible feature into Gravity myself, so I designed it so you could all help out! `;)`

Gravity actually has two tiers of extensibility: **class support** and **plugins**. Class support is far simpler, and gives you a dead simple way to add Gravity support to any `UIView` subclass you may or may not control. Support is added to a class by means of adopting the `GravityElement` protocol. This protocol has only one required method (and a couple of optional ones) that allows you to handle custom attributes for configuring with your class in XML form.

Gravity also has a lower-level hook-based plugin model that allows you to add whatever amazing functionality to Gravity you can dream up. In fact, most of the actual behavior of Gravity is implemented as either class support or plugins, which not only demonstrates how capable the architecture is, but also serves as a handy source of example code!

If you find yourself confused as to the difference between class support and plugins, the simplest way to think of it is like this: class support only deals with the elements in your XML file that represent (and have the same name as) your class. If the work you need to do (and the information you need to access) is limited to that single node (or its child nodes), then all you need is to implement the `GravityElement` protocol on your class/extension. On the other hand, if the functionality you are authoring applies to potentially multiple different elements, (including potentially all elements), a plugin is what you need.

So go wild with plugins and please share what you create! Plugins are like the apps of Gravity: the more there are, the more value the platform has.

###Rapid Prototyping
Once you get the hang of it, Gravity is so simple you can often use it to build *actual* interfaces faster than you could mock them up using a mockup tool. Use it to sketch out a functioning UI for your app in minutes rather than the hours native Auto Layout would take.

Gravity uses all native types (except for the special GravityView), so migrating from a Gravity-based layout to a storyboard or XIB is also very natural. Just make your controller properties IBOutlets and bind them as usual.

But why you would want to do that I have no idea, because…

###No More Interface Builder!
One of the main motivations for Gravity was to break free of the horror known as Interface Builder. Now you can finally architect your interfaces simply and precisely in code. No need for scary wishy-washy mouse-driven interface design anymore. Take complete control of your layout and ditch less worthy paradigms and complex proprietary file formats.

###No More Outlets!
Outlets are a joke. Most frameworks would simply bind interface elements to their code-side counterparts automatically (as does Gravity), but for some reason Apple felt like burdening the user with this bizarre ritual of tying views to their properties manually by dragging lines from Interface Builder into your code file. Okay.

Thankfully this nonsense is gone with Gravity. Interface elements are automatically bound to their controller properties of the same name. So that's one whole paradigm you won't even have to think about anymore when using Gravity.

###Readable Diffs
Because Gravity's syntax is so much simpler than a XIB file, a nice side-effect is that things like source control diffs actually become human-parseable.

##Downsides
###No Immediate Feedback
Probably the biggest limitation of Gravity right now is that you cannot immediately see a visual representation of your UI while editing your layout *in Xcode*. This isn't a limitation of the design of Gravity per se, but more a result of the fact that you cannot instantiate iOS controls inside OS X inside anything other than a simulator. (I honestly don't know how Interface Builder does it, or whether it may be possible some day to integrate Gravity with Xcode's design-time tools, but I suspect Apple keeps much of this proprietary.)

That said, there will be an included demo app called Gravity Assist that will allow you to see the results of adjustments to your layout in real time. The only problem is you have to run it on a device or the simulator. `:(`

I expect things will improve in this area as time goes by, but for now your best bet is to just compile and run to see your changes. One piece of good news is that because xml files are considered merely resources, if you've only modified xml files since your last build, rebuilding is almost instantaneous because everything is already compiled!

###No Unit Testing
There's no unit testing *yet*, but Gravity is clearly something that would benefit greatly from a suite of unit tests, so you can bet they're coming at some point.

##Tips
Gravity is not just an easier way to work with Auto Layout, it's really a whole philosophy: Build your interfaces from the inside out, not the outside in. Let the content be key. Don't waste space. Think contextually.

###Gravity
Gravity (that is the "gravity" attribute) is a **scoped attribute** that controls the general direction of attraction for elements in the interface. It applies to its entire subtree until overridden by a different child value. ("color" is another scoped attribute. You can use it to set the default foreground color of all elements in a subtree, including templated UIImageViews.)

Gravity affects the element it is directly applied to, as well as all of its children. If the element is contained within another view (other than a stack view), and the parent view is bigger than the child, the child will align itself within its parent based on the child's gravity. If the child does not explicitly specify its own gravity, it inherits the gravity from its parent.

Gravity also affects the *containers* (the `<H>` and `<V>` stack views). Gravity may, however, also affect certain views if they implement custom handlers. For example, text elements like UILabel adjust their justification to follow the gravity (including GravityDirection.Wide, which becomes Justified).

Gravity has a special meaning when applied to a UIView.

##More Advanced Stuff
###Class Support
Gravity makes it easy to add XML support to any existing class. If you have control of the class, simply add the `GravityElement` protocol and implement its one required method. If you don't control the class, you can create a class extension that adds support for the GravityElement protocol to any existing class. See the classes in the "Class Support" folder of Gravity for some examples.

###Plugins
If you can't do what you need via the GravityElement protocol, chances are you will need to write a Gravity plugin. Gravity sports a powerful plugin architecture allowing you to insert custom logic at key points and extend the framework to suit your needs. The intention is to make it as flexible as possible, providing the ability for plugins to override default behavior at all of the necessary key points, such as element instantiation, attribute processing, and pre- and post-processing of elements.

One key use of plugins is to handle element instantiation from a node where the default behavior is unsatisfactory. By default, Gravity uses the name of the element to identify a class and instantiate a default (parameterless) instance of that class, which can then be configured by handling the node's attributes in turn. However, if the element name does not correspond to a class name, or the class requires more complicated initialization (e.g. UICollectionView), you can create a Gravity plugin to accomplish this.

A gravity plugin is any class that derives from GravityPlugin and is registered with the framework as a plugin. It must have a parameterless initializer. You pass the *class* into Gravity.registerPlugin(). Gravity will instantiate your plugin class once per document, so you can keep any necessary state inside the plugin instance.

Note that the same class can be at once both a GravityElement and a GravityPlugin when it makes sense to do so. For example, the UIStackView+Gravity extension provides attribute handling for UIStackView elements, but also registers itself as a GravityPlugin in order to explicitly handle the `<H>` and `<V>` shorthand tags.

###Accessing Constraints
You can programmatically get a reference to the native `NSLayoutConstraint` for any of a node's many different constraints by passing a string identifying the constraint, generally by the name of the attribute the constraint affects. This can be very handy for animations or if you need to programmatically adjust a layout in real time.

For example, if you've explicitly set a width, minWidth, maxWidth, etc., you can access the corresponding constraint by passing in "width", "minWidth", and so on.

Note: There are only a handful of these implemented at the moment. More to come.

###Using Custom Scoped Attributes
It is actually quite easy to use your own scoped attributes within gravity. The only real concern is telling gravity not to try to handle that attribute on its own. To do that you'll have to create a GravityPlugin that simply returns `.Handled` from the `processAttribute()` function when passed your custom attribute. Gravity will then consider that attribute handled and will stop trying to process it anymore.

Now you can add your custom attribute anywhere in your layout, and use the `getScopedAttribute()` function of GravityNode to check its inherited value from any node.

##Q&A
**Q: Isn't a XIB file already XML? Why do I need another XML format?**

**A:** Yes, XIB files are XML-based, but they're XML-based as a *serialization format*, not as a language with a user experience. XIB files are not intended to be authored by hand. Gravity, on the other hand, is designed from the ground up to be written by hand and is therefore intentionally simple and concise. Furthermore, XIB's XML format does absolutely nothing to abstract away the pains of Auto Layout. So even if you were to attempt to author a XIB file by hand (seriously though, don't), you'd still be programming with Auto Layout, albeit in a different form. Gravity is an abstraction layer built on top of Auto Layout. XIB is just Interface Builder serialized to XML.

**Q: Doesn't the strictness of the hierarchy restrict the interfaces you can create?**

**A:** Yes, to a degree. This is a natural result of what Gravity is. But you'd be surprised how powerful nested stack views can be, and there's always layering when that fails you. When you start to design with Gravity, you start to think like Gravity. Interfaces tend to just build themselves.

**Q: Is there design-time support for Gravity?**

**A:** Not yet, but this is definitely something I would like to do. I am not sure what is possible and what not at this point. Please contribute if you have any ideas.

**Q: Does Gravity support OS X development?**

**A:** Not yet, but I don't expect this would be too difficult. I just don't have any experience with AppKit on OS X, but I expect it will be very possible to port/extend Gravity to OS X in the near future.

##Requirements
Gravity makes heavy use of the `UIStackView`, so iOS 9 only, I'm afraid! This is brand spankin' new stuff! (Note: I may try to implement support for [TZStackView](https://github.com/tomvanzummeren/TZStackView) to bring support for Gravity to older iOS versions.)

It also depends on Tyler Fox's life-saving [PureLayout](https://github.com/PureLayout/PureLayout) framework as well, for now at least.
