# this, on an object with title = 'ruby'
=begin

### title3

* list item
* list item

--

paragraph with [link](http://localhost:3000/articles), *bold*, _underlined_ and `code = :ruby`.
And even some line jump with **italics**.

```ruby
def some_code
  :ruby
end
```

%
  c = 'coucou'
  content_tag :p, c
%

speaking of %title%. goooood.

+~~~~
  some col-3
+~~~~
  some col-3
+~~
  some col-6
+

#### Conclusion

end of file.
=end



# becomes
=begin
<h3>title3</h3>

<ul>
<li>list item</li>
<li>list item</li>
</ul>

<hr>

<p>paragraph with <a href="http://localhost:3000/articles">link</a>, <strong>bold</strong>, <u>underlined</u> and <span class="CodeRay">code = <span class="symbol">:ruby</span></span>.<br>
And even some line jump with <em>italics</em>.</p>

<div class="CodeRay">
  <div class="code"><pre><span class="keyword">def</span> <span class="function">some_code</span>
  <span class="symbol">:ruby</span>
<span class="keyword">end</span>
</pre></div>
</div>

<p>coucou</p>

<p>speaking of ruby. goooood.</p>

<div class="grid-row">
<div class="grid-col-3"><p>  some col-3</p></div>
<div class="grid-col-3"><p>  some col-3</p></div>
<div class="grid-col-6"><p>  some col-6</p></div>
</div>

<h4>Conclusion</h4>

<p>end of file.<br></p>
=end
