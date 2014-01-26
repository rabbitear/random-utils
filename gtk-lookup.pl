#!/usr/bin/perl -w

use strict;
use Gtk2 '-init';

use Data::Dumper;
use Data::Printer;

use constant TRUE  => 1;
use constant FALSE => 0;

my $window = Gtk2::Window->new('toplevel');
$window->set_title ('LookupWord');
$window->signal_connect (destroy => sub { Gtk2->main_quit; });
$window->set_default_size(500,300);

my $vbox = Gtk2::VBox->new(FALSE, 6);
$window->add($vbox);

# for debugging
#print "window default widget: " . $window->get_default_widget();

#########################
# The input box for text.
my $frame_input = Gtk2::Frame->new('type word:');
my $textinput = Gtk2::Entry->new();
$textinput->set_visibility(TRUE);
$textinput->set_max_length(40);
$textinput->set_icon_from_icon_name("primary","firefox");
$textinput->set_icon_tooltip_text("primary","Hi there, type in your search here");
$textinput->signal_connect ("icon-press" => sub { Gtk2->main_quit; });
$textinput->signal_connect ("backspace" => sub { print "Hi, backspace.\n"; });
$textinput->signal_connect ("activate" => \&lookup_word );
$textinput->set_activates_default(TRUE);
print "activates-default set to: " . $textinput->get_activates_default; 
$vbox->pack_start($frame_input, FALSE, TRUE, 0);
my $hbox2 = Gtk2::HBox->new(FALSE, 6);
$frame_input->add($hbox2);
$hbox2->pack_start($textinput,FALSE,FALSE,0);
#$vbox->add($textinput);

#######################
# TextView for the definitions.
my $scrolledwin = Gtk2::ScrolledWindow->new();
$scrolledwin->set_policy('never','automatic');
my $bufferview = Gtk2::TextBuffer->new();
my $textview = Gtk2::TextView->new_with_buffer($bufferview);
# output of df, just for testing.
my $freeout = "Welcome to the Dictionary, type something:";
$bufferview->insert_at_cursor($freeout);
$scrolledwin->add($textview);
#$vbox->add($textview);
$vbox->add($scrolledwin);


########################################
# A frame and then add an hbox into  it.
my $frame = Gtk2::Frame->new('the buttons');
# the first FALSE is for $expand.
$vbox->pack_start($frame, FALSE, TRUE, 0);
my $hbox = Gtk2::HBox->new(FALSE, 6);
$frame->add($hbox);

############################
# the buttons on the bottom.
my $save_button = Gtk2::Button->new('Save');
$hbox->pack_start($save_button,FALSE,FALSE,0);
my $quit_button = Gtk2::Button->new('Quit');
$quit_button->signal_connect (clicked => sub { Gtk2->main_quit; });
$hbox->pack_start($quit_button,FALSE,FALSE,0);
my $fullscreen_button = Gtk2::Button->new('FS');
$fullscreen_button->signal_connect (clicked => sub { $window->fullscreen; });
$hbox->pack_start($fullscreen_button,FALSE,FALSE,0);
my $unfullscreen_button = Gtk2::Button->new('UNFS');
$unfullscreen_button->signal_connect (clicked => sub { $window->unfullscreen; });
$hbox2->pack_start($unfullscreen_button,FALSE,FALSE,0);



$window->show_all;
Gtk2->main;

sub lookup_word { 
    my $inputtext = $textinput->get_text();
    print "output: " . $textinput->get_text() . "\n";
    $freeout = `sdcv $inputtext`;
    #$bufferview->insert_at_cursor($freeout);
    $bufferview->set_text($freeout);
    1;
}


