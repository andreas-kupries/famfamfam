[comment {-*- tcl -*- --- !doctools --- manpage}]
[manpage_begin famfamfam::[vset NAME] n 1.0.1]
[include module.inc]
[titledesc "FamFamFam [vset UNAME] Icon Set"]
[keywords "icon set [vset NAME]"]
[keywords "[vset NAME] icons"]
[require famfamfam::[vset NAME] [opt 1]]
[comment {% % %% %%% %%%%% %%%%%%%% %%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%}]
[description]
[include welcome.inc]

[para] This package provides a programmatic interface to the FamFamFam
[vset UNAME] Icon Set. It enables the user to access any of the icons
in the set by name.

[para] It resides in the Icon Set level of the architecture
[image arch_[vset NAME]]

[comment {% % %% %%% %%%%% %%%%%%%% %%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%}]
[section API]

[list_begin definitions]
[comment ============================================================]
[call [cmd "::famfamfam [vset NAME] get"] [arg name]]

This command returns a Tk image holding the [vset NAME] icon whose
name was specified as argument of the command. An error will be thrown
instead if the [arg name] is not valid.

[comment ============================================================]
[call [cmd "::famfamfam [vset NAME] list"] [opt [arg pattern]]]

This command returns a list containing the names of all valid
[vset NAME] icons accessible through the package.

If the [arg pattern] is specified then only names matching that
pattern are returned. Matching is done by [cmd {string match}],
i.e. the argument is a [term {glob pattern}].

[comment ============================================================]
[call [cmd "::famfamfam [vset NAME] path"] [arg name]]

This command returns the absolute path of the file containing the
[vset NAME] icon whose name was specified as argument of the
command. An error will be thrown instead if the [arg name] is not
valid.

[list_end]

[comment {% % %% %%% %%%%% %%%%%%%% %%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%}]
[section Examples]

[example_begin]
package require famfamfam::[vset NAME]
set w [lb]famfamfam [vset NAME] list w*[rb]
set [vset EXAMPLE] [lb]famfamfam [vset NAME] get [vset EXAMPLE][rb]
[example_end]

[comment {% % %% %%% %%%%% %%%%%%%% %%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%}]
[section References]

[list_begin enumerated]
[enum]
[uri http://www.famfamfam.com/lab/icons/[vset NAME] \
     "Homepage of the FamFam [vset UNAME] Icon Set"]

[list_end]

[comment {% % %% %%% %%%%% %%%%%%%% %%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%}]
[section Authors]
[list_begin enumerated]
[enum] Code by Andreas Kupries.
[enum] The underlying Icon Set however was created by
[uri mailto:mjames@gmail.com {Mark James}] and is available for free
under a Creative Commons Attribution 2.5 License.

[para] Per the terms of this license we give attribution, see the
previous paragraph, and section ([sectref References]).

[list_end]

[comment {% % %% %%% %%%%% %%%%%%%% %%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%}]
[include feedback.inc]
[manpage_end]
