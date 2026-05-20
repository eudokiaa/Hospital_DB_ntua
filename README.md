# Hospital DB — Βάσεις Δεδομένων 2025-2026

## Ομάδα

Δημήτρης Κάργας ΑΜ: 03122637
Νεκτάριος Ηλιόπουλος AM: 03122640
Ευδοκία Καββαδά ΑΜ: 03122832

---

# Περιγραφή

Σχεδιασμός και υλοποίηση σχεσιακής βάσης δεδομένων για το Γενικό Νοσοκομείο «Υγειόπολης», σύμφωνα με την εκφώνηση του μαθήματος «Βάσεις Δεδομένων» ΣΗΜΜΥ ΕΜΠ 2025-2026.

Η βάση δεδομένων καλύπτει:

- διαχείριση προσωπικού (ιατροί, νοσηλευτές, διοικητικό προσωπικό)
- ασθενείς και ιστορικό νοσηλειών
- triage και επείγοντα περιστατικά
- βάρδιες και εφημερίες
- φαρμακευτική αγωγή
- ιατρικές πράξεις και εξετάσεις
- αξιολογήσεις ασθενών
- κοστολόγηση νοσηλειών μέσω ΚΕΝ
- ICD-10 διαγνώσεις
- constraints και business rules

Το σύστημα σχεδιάστηκε με στόχο:

- normalization
- referential integrity
- realistic hospital workflows
- scalability
- query optimization
- αποδοτική εκτέλεση analytical SQL queries

---

# Features

- Referential integrity μέσω foreign keys
- Complex SQL constraints και triggers
- Automatic hospitalization cost calculation μέσω ΚΕΝ
- ICD-10 diagnosis support
- Emergency triage workflow
- Shift & emergency scheduling
- Recursive supervision hierarchy
- Allergy-aware prescription validation
- Query optimization με indexes και EXPLAIN
- Large-scale synthetic data loading
- Advanced analytical SQL queries

---

# Τεχνολογίες

| Component | Technology |
|---|---|
| RDBMS | MariaDB 10.4+ |
| SQL Client | MySQL Workbench |
| ER Diagram | draw.io (Chen notation) |
| Relational Diagram | MySQL Workbench |
| Backend | Node.js / Express |
| Frontend | React |
| ORM | Δεν χρησιμοποιήθηκε |

---

# Database Statistics

| Metric | Value |
|---|---|
| Tables | 20+ |
| SQL Queries | 15 |
| Triggers | Multiple |
| Foreign Keys | Extensive |
| Indexed Queries | Yes |
| Synthetic Records | 100k+ |
| EXPLAIN Analyses | Included |

---

# Διαγράμματα

Το repository περιλαμβάνει:

- Entity-Relationship Diagram (Chen notation)
- Relational Schema Diagram

Αρχεία:

```text
diagrams/er.pdf
diagrams/relational.pdf
```

---

# Δομή Repository

```text
hospital-db/
├── README.md
├── diagrams/
│   ├── er.pdf
│   └── relational.pdf
├── sql/
│   ├── install.sql
│   ├── load.sql
│   ├── Q01.sql / Q01_out.txt
│   ├── ...
│   ├── Q15.sql / Q15_out.txt
│   ├── Q04_explain.sql / Q04_explain_out.txt
│   └── Q06_explain.sql / Q06_explain_out.txt
├── docs/
│   └── report.pdf
└── code/
    └── web/
```

---

# Οδηγίες Εγκατάστασης

## Προαπαιτούμενα

- MariaDB / MySQL
- XAMPP (προαιρετικά)
- MySQL Workbench ή άλλο SQL client

---

## 1. Clone Repository

```bash
git clone <https://github.com/eudokiaa/Hospital_DB_ntua>
cd hospital-db
```

---

## 2. Δημιουργία Schema

```bash
mysql -u root -p < sql/install.sql
```

Το script:

- δημιουργεί τη βάση `hospital_db`
- δημιουργεί όλους τους πίνακες
- ορίζει primary / foreign keys
- δημιουργεί indexes
- δημιουργεί triggers και constraints

---

## 3. Φόρτωση Δεδομένων

```bash
mysql -u root --local-infile=1 -p < sql/load.sql
```

Το script φορτώνει:

- synthetic hospital data
- ICD-10 datasets
- KEN hospitalization datasets
- medicines
- active substances
- medical procedures
- reference datasets

---

# Εκτέλεση Queries

## Εκτέλεση ενός query

```bash
cd sql
mysql -u root --local-infile=1 hospital_db < Q01.sql > Q01_out.txt
```

---

## Εκτέλεση όλων των queries

```bash
for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15; do
    mysql -u root --local-infile=1 hospital_db < Q${i}.sql > Q${i}_out.txt
done
```

---

# Queries

| Query | Περιγραφή |
|---|---|
| Q01 | Συνολικά έσοδα ανά τμήμα και έτος με ανάλυση ΚΕΝ |
| Q02 | Ιατροί συγκεκριμένης ειδικότητας και χειρουργικές επεμβάσεις |
| Q03 | Ασθενείς με >3 νοσηλείες στο ίδιο τμήμα |
| Q04 | Μέσος όρος αξιολογήσεων ασθενών ανά ιατρό |
| Q05 | Νέοι ιατροί με τις περισσότερες επεμβάσεις |
| Q06 | Ιστορικό νοσηλειών συγκεκριμένου ασθενή |
| Q07 | Στατιστικά αλλεργιών και δραστικών ουσιών |
| Q08 | Προσωπικό χωρίς εφημερία σε συγκεκριμένη ημερομηνία |
| Q09 | Ασθενείς με ίδιο αριθμό ημερών νοσηλείας |
| Q10 | Top-3 combinations δραστικών ουσιών |
| Q11 | Ιατροί με τουλάχιστον 5 λιγότερες επεμβάσεις από τον πρώτο |
| Q12 | Απαιτούμενο προσωπικό ανά βάρδια και τμήμα |
| Q13 | Recursive supervision hierarchy |
| Q14 | ICD-10 category analytics |
| Q15 | Triage analytics και emergency statistics |

---

# Παραδοχές

| # | Παραδοχή |
|---|---|
| 1 | Το επίπεδο επείγοντος triage ορίζεται ως ακέραιος 1-5 |
| 2 | Ο χρόνος αναμονής triage υπολογίζεται από Arrival_time και EntryDate |
| 3 | Κάθε triage συνδέεται με το πολύ μία νοσηλεία |
| 4 | Οι βάρδιες ορίζονται ως morning / evening / night |
| 5 | Το κόστος νοσηλείας υπολογίζεται μέσω trigger |
| 6 | Οι αξιολογήσεις ιατρών συνδέονται μέσω εξετάσεων |
| 7 | Το Q08 χρησιμοποιεί συγκεκριμένη ημερομηνία και τμήμα |
| 8 | Το Q12 χρησιμοποιεί εβδομάδα 2026-04-01 έως 2026-04-07 |
| 9 | Η κυκλική εποπτεία αποτρέπεται μέσω trigger |
| 10 | Απαγορεύεται συνταγογράφηση σε περίπτωση αλλεργίας |
| 11 | Δεν χρησιμοποιείται partial ICD-10 matching |
| 12 | Οι ICD-10 κατηγορίες προκύπτουν από το πρώτο γράμμα |
| 13 | Τα δεδομένα EMA εισάγονται με split δραστικών ουσιών |
| 14 | Οι χειρουργικές αίθουσες δεν επιτρέπουν overlapping επεμβάσεις |
| 15 | Το προσωπικό δεν επιτρέπεται να υπερβαίνει τα όρια βαρδιών |

---

# Constraints & Business Rules

Το σύστημα επιβάλλει:

- referential integrity
- μοναδικότητα κλειδιών
- valid triage levels
- valid shift schedules
- μέγιστα όρια βαρδιών ανά μήνα
- ελάχιστο χρόνο ανάπαυσης 8 ωρών
- αποτροπή >3 συνεχόμενων νυχτερινών βαρδιών
- αποτροπή cyclic supervision
- αποτροπή overlapping χειρουργείων
- αποτροπή prescription conflicts με allergies

Οι παραπάνω περιορισμοί υλοποιούνται μέσω:

- PRIMARY KEY
- FOREIGN KEY
- CHECK constraints
- UNIQUE constraints
- TRIGGERS

---

# Αιτιολόγηση Indexes

| Index | Πίνακας | Στήλη | Χρησιμοποιείται σε |
|---|---|---|---|
| idx_doctor_major | Doctor | Major | Q02, Q05 |
| idx_doctor_rank | Doctor | Rank | Q05, Q11 |
| idx_nurse_department | Nurse | Department_id | Q08, Q12 |
| idx_staff_department | Staff | Department_id | Q08, Q12 |
| idx_bed_department | Bed | Department_id | JOIN νοσηλειών |
| idx_hosp_patient | Hospitalisation | Patient_AMKA | Q03, Q06, Q09 |
| idx_hosp_department | Hospitalisation | Department_id | Q01, Q04, Q12 |
| idx_hosp_ken | Hospitalisation | KEN_id | Q01 |
| idx_exam_hosp | Exam | Hospitalisation_id | JOIN εξετάσεων |
| idx_exam_doctor | Exam | Doctor_AMKA | Q04 |
| idx_presc_patient | Prescription | Patient_AMKA | Q07, Q10 |
| idx_presc_doctor | Prescription | Doctor_AMKA | Q02 |
| idx_shift_date | Shift | Date | Q08, Q12 |
| idx_triage_patient | Triage | Patient_AMKA | Q15 |
| idx_rating_hosp | Rating | Hospitalisation_id | Q04, Q06 |

Τα indexes σχεδιάστηκαν ώστε να βελτιστοποιούν:

- JOIN operations
- filtering conditions
- GROUP BY aggregations
- analytical workloads
- recursive queries

---

# Query Optimization

Για τα queries Q04 και Q06 παρέχονται:

- EXPLAIN / EXPLAIN ANALYZE
- FORCE INDEX alternatives
- σύγκριση execution plans
- σύγκριση estimated cost και execution time
- analysis optimization αποτελεσμάτων

Αρχεία:

```text
Q04_explain.sql
Q04_explain_out.txt
Q06_explain.sql
Q06_explain_out.txt
```

---

# Δεδομένα Αναφοράς

Τα δεδομένα αναφοράς εισήχθησαν από επίσημες πηγές:

- ICD-10 codes
- ΚΕΝ νοσηλειών
- EMA medicines dataset
- Medical procedures datasets

Η εισαγωγή πραγματοποιήθηκε μέσω:

- CSV preprocessing
- LOAD DATA INFILE
- SQL import scripts

---

# Χρήση Εργαλείων Τεχνητής Νοημοσύνης

Κατά την ανάπτυξη του project χρησιμοποιήθηκαν εργαλεία τεχνητής νοημοσύνης αποκλειστικά για:

- debugging SQL queries
- query formulation assistance
- documentation support
- explain plan interpretation

Όλος ο τελικός σχεδιασμός, η κατανόηση, η υλοποίηση και το validation πραγματοποιήθηκαν από τα μέλη της ομάδας.

---



# License

Το project αναπτύχθηκε αποκλειστικά για εκπαιδευτικούς και ακαδημαϊκούς σκοπούς.
