module SmerTags
  include Radiant::Taggable
  class TagError < StandardError; end 
  
  desc %{
    Generates a form for submitting email.
    Usage:
    <pre><code>  <r:smer:form>...</r:smer:form></code></pre>}
  tag "smer:form" do |tag|
    results = [%(<a name="smer"></a>)]
    results << %(<form action="/pages/#{tag.locals.page.id}/smer#mailer" method="post" >)
    results <<   tag.expand
    results << %(</form>)
  end
  
  desc %{
    Renders a <textarea>...</textarea> tag for a mailer form. The 'name' attribute is required. }
  tag 'smer:textarea' do |tag|
    raise_error_if_name_missing "smer:textarea", tag.attr
    result =  [%(<textarea #{mailer_attrs(tag, 'rows' => '5', 'cols' => '35')}>)]
    result << (prior_value(tag) || tag.expand)
    result << "</textarea>"
    add_required(result, tag)
  end  
  
  %w(text checkbox radio hidden).each do |type|
    desc %{
      Renders a #{type} input tag for a mailer form. The 'name' attribute is required.}
    tag "mailer:#{type}" do |tag|
      raise_error_if_name_missing "mailer:#{type}", tag.attr
      value = (prior_value(tag) || tag.attr['value'])
      result = [%(<input type="#{type}" value="#{value}" #{mailer_attrs(tag)} />)]
      add_required(result, tag)
    end
  end

  desc %{
    Renders a @<select>...</select>@ tag for a mailer form.  The 'name' attribute is required.
    @<r:option />@ tags may be nested inside the tag to automatically generate options.}
  tag 'mailer:select' do |tag|
    raise_error_if_name_missing "mailer:select", tag.attr
    tag.locals.parent_tag_name = tag.attr['name']
    tag.locals.parent_tag_type = 'select'
    result = [%Q(<select #{mailer_attrs(tag, 'size' => '1')}>)]
    result << tag.expand
    result << "</select>"
    add_required(result, tag)
  end

  

  %{
    Renders a series of @<input type="radio" .../>@ tags for a mailer form.  The 'name' attribute is required.
    Nested @<r:option />@ tags will generate individual radio buttons with corresponding values. }
  tag 'mailer:radiogroup' do |tag|
    raise_error_if_name_missing "mailer:radiogroup", tag.attr
    tag.locals.parent_tag_name = tag.attr['name']
    tag.locals.parent_tag_type = 'radiogroup'
    tag.expand
  end

  desc %{ Renders an @<option/>@ tag if the parent is a
    @<r:mailer:select>...</r:mailer:select>@ tag, an @<input type="radio"/>@ tag if
    the parent is a @<r:mailer:radiogroup>...</r:mailer:radiogroup>@ }
  tag 'mailer:option' do |tag|
    tag.attr['name'] = tag.locals.parent_tag_name

    value = (tag.attr['value'] || tag.expand)
    selected = (prior_value(tag, tag.locals.parent_tag_name) == value)

    if tag.locals.parent_tag_type == 'select'
      %(<option value="#{value}"#{%( selected="selected") if selected} #{mailer_attrs(tag)}>#{tag.expand}</option>)
    elsif tag.locals.parent_tag_type == 'radiogroup'
      %(<input type="radio" value="#{value}"#{%( selected="selected") if selected} #{mailer_attrs(tag)} />)
    end
  end


#############################################################################

  desc %{ All mailer-related tags live inside this one. }
  tag "mailer" do |tag|
    if !Mail.valid_config?(config)
      "Mailer config is not valid (see Mailer.valid_config?)"
    else
      tag.expand
    end
  end
  
  desc %{
    Will expand if and only if there is an error with the last mail.

    If you specify the "on" attribute, it will only expand if there
    is an error on the named attribute, and will make the error
    message available to the mailer:error:message tag.}
  tag "mailer:error" do |tag|
    if mail = tag.locals.page.last_mail
      if on = tag.attr['on']
        if error = mail.errors[on]
          tag.locals.error_message = error
          tag.expand
        end
      else
        if !mail.valid?
          tag.expand
        end
      end
    end
  end
  
  desc %{Outputs the error message.}
  tag "mailer:error:message" do |tag|
    tag.locals.error_message
  end

  
  desc %{
    Outputs a bit of javascript that will cause the enclosed content
    to be displayed when mail is successfully sent.}
  tag "mailer:form:success" do |tag|
    results = [%(<div id="mail_sent" style="display:none">)]
    results << tag.expand
    results << %(</div>)
    results << %(<script type="text/javascript">if($ && location.hash == '#mail_sent'){$('mail_sent').show();}</script>)
    results
  end

  desc %{
    Renders the value of a datum submitted via a mailer form.  Used in the 'email', 'email_html', and
    'mailer' parts to generate the resulting email. }
  tag 'mailer:get' do |tag|
    name = tag.attr['name']
    mail = tag.locals.page.last_mail
    if name
      mail.data[name].is_a?(Array) ? mail.data[name].to_sentence : mail.data[name]
    else
      mail.data.to_hash.to_yaml.to_s
    end
  end
  
  def prior_value(tag, tag_name=tag.attr['name'])
    if mail = tag.locals.page.last_mail
      mail.data[tag_name]
    else
      nil
    end
  end

  def mailer_attrs(tag, extras={})
    attrs = {
      'id' => tag.attr['name'], 
      'class' => nil, 
      'size' => nil}.merge(extras)
    result = attrs.collect do |k,v|
      v = (tag.attr[k] || v)
      next if v.blank?
      %(#{k}="#{v}")
    end.reject{|e| e.blank?}
    result << %(name="mailer[#{tag.attr['name']}]") unless tag.attr['name'].blank?
    result.join(' ')
  end
  
  def add_required(result, tag)
    result << %(<input type="hidden" name="mailer[required][#{tag.attr['name']}]" value="#{tag.attr['required']}" />) if tag.attr['required']
    result
  end

  def raise_error_if_name_missing(tag_name, tag_attr)
    raise "`#{tag_name}' tag requires a `name' attribute" if tag_attr['name'].blank?
  end
end
