#!/usr/bin/perl -w

use DBI;
use strict;

my $wybor = 0;

do {
	system("clear");
	print "============== MENU ==============\n";
	print "1) Stwórz tabele\n";
	print "2) Wyświetl tabele\n";
	print "3) Dodaj dane do tabeli\n";
	print "4) Wyświetl dane w tabeli\n";
	print "5) Edytuj dane w tabeli\n";
	print "6) Usuń dane w tabeli\n";
	print "7) Usuń tabele\n";
	print "\n";
	print "0) Wyjście\n";
	chomp($wybor = <STDIN>);

	my $dbh = DBI->connect('DBI:mysql:db_perl', 'perl_user', 'Z8nIilL3323Ee') or die "Nie można połączyć z bazą: ".$DBI::errstr;
	my $tab = "";
	my $exists = undef;

	if($wybor ne "0") { system("clear"); }

	if($wybor eq "1") {
		print "============= STWÓRZ =============\n";
		do {
			print "Podaj nazwę tabeli: ";
			chomp($tab = <STDIN>);
		} while(length($tab) == 0);
		my $prep = $dbh->prepare('CREATE TABLE '.$tab.'(id SERIAL PRIMARY KEY, value VARCHAR(256));') or die "Nie można utworzyć tabeli (1): ".$dbh->errstr();
		$prep->execute() or die "Nie można wykonać SQL (1): ".$prep->errstr();
		print "\nPomyślnie wykonano!\nAby wrócić do menu naciśnij ENTER...\n";
		<STDIN>;

	} elsif($wybor eq "2") {
		print "======== WYŚWIETL TABELE =========\n";
		my $prep = $dbh->prepare("SHOW TABLES;") or die "Nie można wyświetlić tabel (2): ".$dbh->errstr();
		$prep->execute() or die "Nie można wykonać SQL (21): ".$prep->errstr();
		while(my $t = $prep->fetchrow_array()) {
			print $t, $/;
		}

		print "\nAby wrócić do menu naciśnij ENTER...\n";
		<STDIN>;

	} elsif($wybor eq "3") {
		print "============= DODAJ ==============\n";
		do {
			do {
				print "Podaj nazwę tabeli: ";
				chomp($tab = <STDIN>);
			} while(length($tab) == 0);

			my $prep = $dbh->prepare("SHOW TABLES LIKE '$tab';") or die "Nie można wyświetlić tabel (3): ".$dbh->errstr();
			$prep->execute() or die "Nie można wykonać SQL (31): ".$prep->errstr();
			if($prep->rows > 0) { $exists = 1 };
			$prep->finish();
		} while(!defined($exists));
		print "\n";
		my $val = "";

		do {
			print "Podaj wartość 'value': ";
			chomp($val = <STDIN>);
		} while(length($val) == 0);

		my $prep = $dbh->prepare("INSERT INTO ".$tab."(value) values ('".$val."');") or die "Nie można dodać do tabeli (32): ".$dbh->errstr();
		$prep->execute() or die "Nie można wykonać SQL (33): ".$prep->errstr();
		print "\nPomyślnie wykonano!\nAby wrócić do menu naciśnij ENTER...\n";
		<STDIN>;

	} elsif($wybor eq "4") {
		print "============ WYŚWIETL ============\n";
		do {
			do {
				print "Podaj nazwę tabeli: ";
				chomp($tab = <STDIN>);
			} while(length($tab) == 0);

			my $prep = $dbh->prepare("SHOW TABLES LIKE '$tab';") or die "Nie można wyświetlić tabel (4): ".$dbh->errstr();
			$prep->execute() or die "Nie można wykonać SQL (41): ".$prep->errstr();
			if($prep->rows > 0) { $exists = 1 };
			$prep->finish();
		} while(!defined($exists));
		print "\n";
		my $prep = $dbh->prepare("SELECT id, value FROM ".$tab.";") or die "Nie można wyświetlić zawartości tabel (42): ".$dbh->errstr();
		$prep->execute() or die "Nie można wykonać SQL (43): ".$prep->errstr();
		print "ID | Value\n";
		while(my @row = $prep->fetchrow_array()) {
			print "$row[0] | $row[1]\n";
		}
		print "\nAby wrócić do menu naciśnij ENTER...\n";
		<STDIN>;

	} elsif($wybor eq "5") {
		print "============= EDYTUJ =============\n";
		do {
			do {
				print "Podaj nazwę tabeli: ";
				chomp($tab = <STDIN>);
			} while(length($tab) == 0);

			my $prep = $dbh->prepare("SHOW TABLES LIKE '$tab';") or die "Nie można wyświetlić tabel (5): ".$dbh->errstr();
			$prep->execute() or die "Nie można wykonać SQL (51): ".$prep->errstr();
			if($prep->rows > 0) { $exists = 1 };
			$prep->finish();
		} while(!defined($exists));
		print "\n";
		my $id = 0;
		my $val = "";

		$exists = undef;

		do {
			do {
				print "Podaj ID wiersza: ";
				chomp($id = <STDIN>);
			} while($id =~ /\D/ || $id < 1);

			my $prep = $dbh->prepare("SELECT value FROM ".$tab." WHERE id=".$id.";") or die "Nie można wybrać zawartości tabeli (52): ".$dbh->errstr();
			$prep->execute() or die "Nie można wykonać SQL (53): ".$prep->errstr();
			if($prep->rows > 0) { $exists = 1 };
			$prep->finish();
		} while(!defined($exists));
		print "\n";
		do {
			print "Podaj nową wartość 'value' dla id=".$id.":\n";
			chomp($val = <STDIN>);
		} while(length($val) == 0);

		my $prep = $dbh->prepare("UPDATE ".$tab." SET value='".$val."' WHERE id=".$id.";") or die "Nie można zaktualizować tabeli (54): ".$dbh->errstr();
		$prep->execute() or die "Nie można wykonać SQL (55): ".$prep->errstr();
		print "\nPomyślnie wykonano!\nAby wrócić do menu naciśnij ENTER...\n";
		<STDIN>;

	} elsif($wybor eq "6") {
		print "=========== USUŃ DANE ============\n";
		do {
			do {
				print "Podaj nazwę tabeli: ";
				chomp($tab = <STDIN>);
			} while(length($tab) == 0);

			my $prep = $dbh->prepare("SHOW TABLES LIKE '$tab';") or die "Nie można wyświetlić tabel (6): ".$dbh->errstr();
			$prep->execute() or die "Nie można wykonać SQL (61): ".$prep->errstr();
			if($prep->rows > 0) { $exists = 1 };
			$prep->finish();
		} while(!defined($exists));
		print "\n";
		my $id = 0;
		my $val = "";
		my $potw = 0;

		$exists = undef;

		do {
			do {
				print "Podaj ID wiersza: ";
				chomp($id = <STDIN>);
			} while($id =~ /\D/ || $id < 1);

			my $prep = $dbh->prepare("SELECT value FROM ".$tab." WHERE id=".$id.";") or die "Nie można wybrać zawartości tabeli (62): ".$dbh->errstr();
			$prep->execute() or die "Nie można wykonać SQL (63): ".$prep->errstr();
			if($prep->rows > 0) { $exists = 1; $val = $prep->fetchrow_array(); }
			$prep->finish();
		} while(!defined($exists));
		print "\n";
		do {
			print "Czy na pewno chcesz usunąć element o ID=".$id." (".$val.")? [1 - TAK / 0 - NIE] ";
			chomp($potw = <STDIN>);
		} while($potw =~ /[^10]/ || length($potw) > 1 || length($potw) == 0);

		if($potw eq "1") {
			my $prep = $dbh->prepare("DELETE FROM ".$tab." WHERE id=".$id.";") or die "Nie można usunąć wartości z tabeli (64): ".$dbh->errstr();
			$prep->execute() or die "Nie można wykonać SQL (65): ".$prep->errstr();
			print "\nPomyślnie wykonano!\nAby wrócić do menu naciśnij ENTER...\n";
			<STDIN>;
		}

	} elsif($wybor eq "7") {
		print "========== USUŃ TABELE ===========\n";
		do {
			do {
				print "Podaj nazwę tabeli: ";
				chomp($tab = <STDIN>);
			} while(length($tab) == 0);

			my $prep = $dbh->prepare("SHOW TABLES LIKE '$tab';") or die "Nie można wyświetlić tabel (7): ".$dbh->errstr();
			$prep->execute() or die "Nie można wykonać SQL (71): ".$prep->errstr();
			if($prep->rows > 0) { $exists = 1 };
			$prep->finish();
		} while(!defined($exists));
		print "\n";
		my $potw = 0;
		do {
			print "Czy na pewno chcesz usunąć podaną tabelę i całą jej zawartość? [1 - TAK / 0 - NIE] ";
			chomp($potw = <STDIN>);
		} while($potw =~ /[^10]/ || length($potw) > 1 || length($potw) == 0);

		if($potw eq "1") {
			my $prep = $dbh->prepare("DROP TABLE IF EXISTS ".$tab.";") or die "Nie można usunąć tabeli (72): ".$dbh->errstr();
			$prep->execute() or die "Nie można wykonać SQL (73): ".$prep->errstr();
			print "\nPomyślnie wykonano!\nAby wrócić do menu naciśnij ENTER...\n";
			<STDIN>;
		}

	}

	$dbh->disconnect();

} while($wybor ne "0");