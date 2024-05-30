# Xcode for Rails apps

This is setup code to allow you to run your Rails app's test suite when you
build in Xcode.

1. Create an Xcode project and move your Rails app code into that project.
   If you already have your Rails app under source control you may wish to
   Create an Xcode project, move the .xcodeproj file into your Rails app's
   directory, then import references to all your existing files into your
   Xcode project. Depending on your project layout, this part may take some
   tinkering to get right.

2. Create a minitest directory in your app's lib directory, then add
   the `xcode_plugin.rb` into that lib/minitest directory.

3. Add a Run Script phase to your Xcode project, deselect its
   "Based on dependency analysis" option, and in the script run your
   tests. For example, if in step 1 you placed all your Rails app's
   code at the top level next to the project:
   
   `/opt/homebrew/opt/ruby/bin/ruby bin/rails test --xcode --defer-output`

Building the project should now run `rails test`. If any tests fail, the
build should "fail", and Xcode should indicate warnings for all the lines
of test code where a test failed.


Q&A
---

_What's going on here?_

> `xcode_plugin.rb` is a MiniTest plugin that emits Xcode-readable warnings
> warnings for any failed tests.

_How supported is this?_

> Not at all, though it does take use MiniTest's existing plugin system
> to play well with Xcode's existing mechanism for reading warnings from
> command line tools.

_Does it work with rspec, or other BDD frameworks?_

> Probably not, but it should be fairly easy to extend things if those tools
> can emit warnings in the right format:
>
>  1. Write a formatter to spit out warnings in the same format as this one.
>  2. Modify the Run Script build phase to call the test command.

_Why did you use the build command instead of the test command?_

> Xcode's and Rails' models running and testing during development are not
> similar. Xcode's test is a fairly heavyweight operation that supposes
> starting and stopping the app as part of the test, whereas Rails model
> typically involves testing seperately and leaving the app running while
> doing so. In addition, Rails doesn't really have a concept of "building"
> an app, since there is no explicit compilation in Ruby. Finally, there
> isn't an easy way to bridge Rails test results into Xcode's test result
> viewer. As such, this project aimed to use Xcode as a competent source
> editor that could quickly execute Rails tests and show their results in
> a useful place for the developer.
