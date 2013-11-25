# --
# Kernel/Modules/DynamicFieldAutocompleteText.pm - provides a dynamic fields text config view for admins
# Copyright (C) 2013 Mike McMahon, http://mikemcmahon.github.io
# --
# $Id: DynamicFieldAutocompleteText.pm,v 1.32 2012/11/20 14:37:27 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::DynamicFieldAutocompleteText;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::System::Valid;
use Kernel::System::CheckItem;
use Kernel::System::DynamicField;
use Kernel::System::Encode; 
use Kernel::System::CustomerUser; 
use Kernel::System::User;
use Kernel::System::Time; 

use vars qw($VERSION);
$VERSION = qw($Revision: 1.32 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    for (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create additional objects
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );
    $Self->{EncodeObject} = Kernel::System::Encode->new( %{$Self} ); 
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} ); 
    $Self->{TimeObject} = Kernel::System::Time->new( %{$Self} ); 
    $Self->{UserObject} = Kernel::System::User->new( %{$Self} ); 

    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );

    # get configured object types
    $Self->{ObjectTypeConfig} = $Self->{ConfigObject}->Get('DynamicFields::ObjectType');

    # get the fields config
    $Self->{FieldTypeConfig} = $Self->{ConfigObject}->Get('DynamicFields::Backend') || {};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $SearchTerm = $Self->{ParamObject}->GetParam( Param => 'term' ); 

    if ( !defined $SearchTerm ) { 
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "A search term must be specified!",
        );
    }

    if ( $Self->{Subaction} eq 'Customer' ) {
        my %Results = $Self->{CustomerUserObject}->CustomerSearch( Search => $SearchTerm );

        my @LoginNames = (); 
        while (my ($Key, $Value) = each (\%Results)) { 
            push(@LoginNames, $Value ); 
        }

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $Self->{LayoutObject}->JSONEncode(Data =>  \@LoginNames ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    elsif ( $Self->{Subaction} eq 'Agent' ) {
        my %Results = $Self->{UserObject}->UserSearch( Search => $SearchTerm );

        my @LoginNames = (); 
        while (my ($Key, $Value) = each (\%Results)) { 
            push(@LoginNames, $Value ); 
        }

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $Self->{LayoutObject}->JSONEncode(Data =>  \@LoginNames ),
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    elsif ( $Self->{Subaction} eq 'Both' ) { 
    }

    return $Self->{LayoutObject}->ErrorScreen(
        Message => "Undefined subaction.",
    );
}

1;
