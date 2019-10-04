![](https://assets-global.website-files.com/5b69e8315733f2850ec22669/5b749a4663ff82be270ff1f5_GSC%20Lockup%20(Orange%20%3A%20Black).svg)

### Welcome to the take home portion of your interview! We're excited to jam through some technical stuff with you, but first it'll help to get a sense of how you work through data and coding problems. Work through what you can independently, but do feel free to reach out if you have blocking questions or problems.

#### 1) This requires Postgres (9.4+) & Rails(4.2+), so if you don't already have both installed, please install them.

I've started by creating a Rails app with a Postgres database and added the forked repo as the remote. I'm going to detail my process in this README as I move down the list. My first commit was after initializing the Rails application.

#### 2) Download the data file from: https://github.com/gospotcheck/ps-code-challenge/blob/master/Street%20Cafes%202015-16.csv

I have pulled down the README and CSV file and I'm going to make a rake task to import it into the Postgres DB. Before I do that, I need to make the table. I generated the model and migration and had to use an inflection support to keep it from pluralizing street cafes to street "caves". I created the rake task using the CSV::foreach method to put them in the database. I used header converters to match the headers to the lower_and_snake_cased table columns. I had to manually replace the unnamed column with a name I picked, 'notes'. Only one cafe has a value for this. I also renamed the café name column because the accent wasn't being read correctly.

In a real scenario, if I had access to the CSV file on my system like I do, I would just alter the headers directly. This is less expensive and would take seconds on my part, but I felt it was weird to alter the CSV file for the purpose of a code challenge, especially since there could be a case where I wouldn't have edit access to it like I do.

I was able to successfully import the data into my development DB. I confirmed it using the Rails Console. I will commit my progress.

#### 3) Add a varchar column to the table called `category`.

I added a varchar category column to the street_cafes table using a rails migration. I will commit.

#### 4) Create a view with the following columns[provide the view SQL]
    - post_code: The Post Code
    - total_places: The number of places in that Post Code
    - total_chairs: The total number of chairs in that Post Code
    - chairs_pct: Out of all the chairs at all the Post Codes, what percentage does this Post Code represent (should sum to 100% in the whole view)
    - place_with_max_chairs: The name of the place with the most chairs in that Post Code
    - max_chairs: The number of chairs at the place_with_max_chairs

I have not worked directly with SQL views in the past. I have always used queries in my models to display them in a Rails view, or as JSON. I'm going to start with a simple Rails method to make sure the query is right (I'll include a model test to ensure the accuracy of the query), and then when I confirm that I will investigate how exactly to create this as a SQL view.

I was able to construct an SQL query that created the columns mentioned above. I tested it using a model test in Rails for a class method on the StreetCafe object. I then used Rails DB to test it out and created an SQL view there.

    *Please also include a brief description of how you verified #4*

The SQL I used to generate the view was:

```
CREATE VIEW street_cafe_data_by_post_code AS
  SELECT post_code,
    COUNT(street_address) as total_places,
    SUM(number_of_chairs) as total_chairs,
    MAX(number_of_chairs) as max_chairs,
    ROUND((SUM(number_of_chairs)*100.0 / (SELECT SUM(number_of_chairs) FROM street_cafes) ), 2) as chairs_pct,
    (SELECT "café/restaurant_name" FROM street_cafes sc2 WHERE sc2.post_code = sc1.post_code ORDER BY number_of_chairs DESC LIMIT 1) as place_with_max_chairs
    FROM street_cafes sc1
    GROUP BY post_code
    ORDER BY post_code;
```

Here is the SQL View:

![Alt text](lib/sql_view_for_street_cafes_by_post_code.png?raw=true "post_code SQL VIEW")

I confirmed and verified it by testing a small subset in my Rails app at first, but when I made the full view, I checked a few post codes for having the right number of places, chairs and the right place with the most chairs. I tested the percentages by calling:

```
SELECT SUM(street_cafe_data_by_post_code.chairs_pct) FROM street_cafe_data_by_post_code;
```

on the view and seeing that it totaled 100.0.

#### 5) Write a Rails script to categorize the cafes and write the result to the category according to the rules:[provide the script]
    - If the Post Code is of the LS1 prefix type:
        - `# of chairs less than 10: category = 'ls1 small'`
        - `# of chairs greater than or equal to 10, less than 100: category = 'ls1 medium'`
        - `# of chairs greater than or equal to 100: category = 'ls1 large' `
    - If the Post Code is of the LS2 prefix type:
        - `# of chairs below the 50th percentile for ls2: category = 'ls2 small'`
        - `# of chairs above the 50th percentile for ls2: category = 'ls2 large'`
    - For Post Code is something else:
        - `category = 'other'`

For this, I created a class called CafeCategorizer that handled the logic for categorizing cafes and updating the db with the category. Both the script and class are in this repo in the /lib/tasks/categorize.rake file and app/models/cafe_categorizer.rb file, respectively. The script is:

```
namespace :categorize do
  desc 'categorize cafes by code and size'
  task street_cafes: :environment do
    cafes = StreetCafe.all
    cafes.each do |cafe|
      cc = CafeCategorizer.new(cafe)
      cc.add_category_to_cafe
    end
    puts "Cafes have been categorized!"
  end
end
```
Task: https://github.com/timnallen/ps-code-challenge/blob/master/lib/tasks/categorize.rake

```
rake categorize:street_cafes
```

And the class is: https://github.com/timnallen/ps-code-challenge/blob/master/app/models/cafe_categorizer.rb

    *Please share any tests you wrote for #5*

I had never written a test for a task before, so I did some research and found I could unit test the class I created and perform the functionality all inside the model layer. The tests evaluated each case. The test is in the repo at:

https://github.com/timnallen/ps-code-challenge/blob/master//spec/models/cafe_categorizer_spec.rb

I also evaluated the task worked properly by playing around in my developer database with Rails C. I even dropped everything, re-imported everything and ran it again to the same results.

#### 6) Write a custom view to aggregate the categories [provide view SQL AND the results of this view]
    - category: The category column
    - total_places: The number of places in that category
    - total_chairs: The total chairs in that category

Similarly to number 4, I am going to build a class method for street cafes and unit test it first. I have committed that.

I will construct the view in Rails DB with the SQL and post it here with the query, view and results:

Query:
```
CREATE VIEW street_cafe_data_by_category AS
  SELECT category,
    COUNT(id) as total_places,
    SUM(number_of_chairs) as total_chairs
    FROM street_cafes
    GROUP BY category
    ORDER BY category;
```
View:

![Alt text](lib/sql_view_for_street_cafes_by_category.png?raw=true "category SQL VIEW")

Results:

ls1 large: 1 place, 152 chairs
ls1 medium: 49 places, 1223 chairs
ls1 small: 11 places, 64 chairs
ls2 large: 5 places, 489 chairs
ls2 small: 5 places, 84 chairs
other: 2 places, 67 chairs

#### 7) Write a script in rails to:
    - For street_cafes categorized as small, write a script that exports their data to a csv and deletes the records
    - For street cafes categorized as medium or large, write a script that concatenates the category name to the beginning of the name and writes it back to the name column

I will start with the latter using the same method used in number 5.

The café/restaurant_name column has finally caught up with me. I cannot access the property with the name as is using ruby methods, so I will change the column name (to 'name'). I'll need to go back and adjust the some queries and tests.

I have made a StreetCafe class method to get all the medium and large cafes and a NameAdjuster class that concatenates the category to the front of the name column.

I need a StreetCafe class method to fetch only small cafes, an exporter function and a delete function. The latter two can perhaps be methods in the same CafeExporter class. I can turn the small cafe class method into the same method as the medium and large with a different argument.

I have made and tested a method to generate the CSV and to delete the records. They have been unit tested and I have manually tested the rake task multiple times.

The task to export and delete the small cafes is:

```
namespace :export_and_delete do
  desc 'exports small Street Cafes into CSV and expunges them'
  task small_street_cafes: :environment do
    exporter = CafeExporter.new(StreetCafe.cafes_by_size('small'))
    csv = exporter.export_to_csv
    File.write("small-cafes-#{Date.today}.csv", csv)
    exporter.expunge_from_database
    puts 'Small Street Cafes exported and expunged from the database!'
  end
end
```
Task: https://github.com/timnallen/ps-code-challenge/blob/master/lib/tasks/export_and_delete.rake

```
rake export_and_delete:small_street_cafes
```

The corresponding class built for this lives in:

https://github.com/timnallen/ps-code-challenge/blob/master/app/model/cafe_exporter.rb

The file has been created in the base folder:

https://github.com/timnallen/ps-code-challenge/blob/master/small-cafes-2019-10-04.csv

The task to rename the medium and large ones is:

```
namespace :rename do
  desc 'rename medium and large street cafes to include category'
  task medium_and_large_street_cafes: :environment do
    medium_and_large_cafes = StreetCafe.cafes_by_size('medium', 'large')
    medium_and_large_cafes.each do |cafe|
      name_adjuster = NameAdjuster.new(cafe)
      name_adjuster.adjust_names
    end
    puts 'Medium and large street cafes renamed!'
  end
end
```

Task: https://github.com/timnallen/ps-code-challenge/blob/master/lib/tasks/rename.rake

```
rake rename:medium_and_large_street_cafes
```

The corresponding class built for this lives in:

https://github.com/timnallen/ps-code-challenge/blob/master/app/model/name_adjuster.rb

    *Please share any tests you wrote for #7*

I wrote several unit tests for this step found at:

https://github.com/timnallen/ps-code-challenge/blob/master/spec/models/cafe_exporter_spec.rb
https://github.com/timnallen/ps-code-challenge/blob/master/spec/models/name_adjuster_spec.rb

and included a fixture to compare to the newly created CSV:

https://github.com/timnallen/ps-code-challenge/blob/master/spec/fixtures/fake.csv

#### 8) Show your work and check your email for submission instructions.

I sincerely hope this is along the lines of what you were looking for in terms of submission. I enjoyed this exercise as I had to learn how to do a few things for the first time, including: creating a SQL view directly (which I hope this was what you meant by this), and exporting data to CSVs. I also had to figure out how to subquery in order to solve the first SQL query. Please let me know if you have any questions or would like me to rework or update a few things. I'm eager to learn more about the best practices and solutions for these problems!

#### 9) Celebrate, you did great!

Will do! Thanks!
