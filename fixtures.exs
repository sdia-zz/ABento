use Amnesia
use Database


Amnesia.transaction do
  john = %User{name: "John", email: "john@example.com"} |> User.write
  richard = %User{name: "Richard", email: "richard@example.com"} |> User.write
  linus   = %User{name: "Linus", email: "linus@example.com"} |> User.write



  john |> User.add_message( """
  When we program a computer to make choices intelligently after determining
  its options, examining their consequences, and deciding which is most
  favorable or most moral or whatever, we must program it to take an attitude
  towards its freedom of choice essentially isomorphic to that which a human
  must take to his own.
  """)

  john |> User.add_message("""
  He who refuses to do arithmetic is doomed to talk nonsense."
  """)

  john |> User.add_message("""
  It's difficult to be rigorous about whether a machine really 'knows',
  'thinks', etc., because we're hard put to define these things. We understand
  human mental processes only slightly better than a fish understands swimming.
  """)

  richard |> User.add_message( """
  For personal reasons, I do not browse the web from my computer. (I also have
  no net connection much of the time.) To look at page I send mail to a daemon
  which runs wget and mails the page back to me. It is very efficient use of my
  time, but it is slow in real time.
  """)

  richard |> User.add_message( """
  I am skeptical of the claim that voluntarily pedophilia harms children. The
  arguments that it causes harm seem to be based on cases which aren't
  voluntary, which are then stretched by parents who are horrified by the idea
  that their little baby is maturing.
  """)

  linus |> User.add_message( """
  Portability is for people who cannot write new programs.
  """)

  linus |> User.add_message( """
  Really, I'm not out to destroy Microsoft. That will just be a completely
  unintentional side effect.
  """)

  linus |> User.add_message( """
  Modern PCs are horrible. ACPI is a complete design disaster in every way. But
  we're kind of stuck with it. If any Intel people are listening to this and
  you had anything to do with ACPI, shoot yourself now, before you reproduce.
  """)


  IO.puts(Message.count())
  IO.puts(User.count())

end



Amnesia.transaction do
#   john = User.read(18)
#   john |> User.messages |> Enum.each(&IO.puts(&1.content))
#   selection = Message.where true    # user_id > 1,
#       # select: content
#
#   selection |> Amnesia.Selection.values |> Enum.each(&IO.puts(&1.content))

  IO.puts(Message.count())
  IO.puts(User.count())
end
IO.puts(Application.get_env(:mnesia, :dir))
IO.puts(Amnesia.Helper.Options)

:mnesia.dump_log()
