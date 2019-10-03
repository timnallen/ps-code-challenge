![](https://assets-global.website-files.com/5b69e8315733f2850ec22669/5b749a4663ff82be270ff1f5_GSC%20Lockup%20(Orange%20%3A%20Black).svg)

### Welcome to the take home portion of your interview! We're excited to jam through some technical stuff with you, but first it'll help to get a sense of how you work through data and coding problems. Work through what you can independently, but do feel free to reach out if you have blocking questions or problems.

1) This requires Postgres (9.4+) & Rails(4.2+), so if you don't already have both installed, please install them.

I've started by creating a Rails app with a Postgres database and added the forked repo as the remote. I'm going to detail my process in this README as I move down the list. My first commit was after initializing the Rails application.

2) Download the data file from: https://github.com/gospotcheck/ps-code-challenge/blob/master/Street%20Cafes%202015-16.csv

I have pulled down the README and CSV file and I'm going to make a rake task to import it into the Postgres DB. Before I do that, I need to make the table. I generated the model and migration and had to use an inflection support to keep it from pluralizing street cafes to street "caves". I created the rake task using the CSV::foreach method to put them in the database. I used header converters to match the headers to the lower_and_snake_cased table columns. I had to manually replace the unnamed column with a name I picked, 'notes'. Only one cafe has a value for this. I also renamed the café name column because the accent wasn't being read correctly.

In a real scenario, if I had access to the CSV file on my system like I do, I would just alter the headers directly. This is less expensive and would take seconds on my part, but I felt it was weird to alter the CSV file for the purpose of a code challenge, especially since there could be a case where I wouldn't have edit access to it like I do.

I was able to successfully import the data into my development DB. I confirmed it using the Rails Console. I will commit my progress.

3) Add a varchar column to the table called `category`.

I added a varchar category column to the street_cafes table using a rails migration. I will commit.

4) Create a view with the following columns[provide the view SQL]
    - post_code: The Post Code
    - total_places: The number of places in that Post Code
    - total_chairs: The total number of chairs in that Post Code
    - chairs_pct: Out of all the chairs at all the Post Codes, what percentage does this Post Code represent (should sum to 100% in the whole view)
    - place_with_max_chairs: The name of the place with the most chairs in that Post Code
    -max_chairs: The number of chairs at the place_with_max_chairs

    *Please also include a brief description of how you verified #4*

5) Write a Rails script to categorize the cafes and write the result to the category according to the rules:[provide the script]
    - If the Post Code is of the LS1 prefix type:
        - `# of chairs less than 10: category = 'ls1 small'`
        - `# of chairs greater than or equal to 10, less than 100: category = 'ls1 medium'`
        - `# of chairs greater than or equal to 100: category = 'ls1 large' `
    - If the Post Code is of the LS2 prefix type:
        - `# of chairs below the 50th percentile for ls2: category = 'ls2 small'`
        - `# of chairs above the 50th percentile for ls2: category = 'ls2 large'`
    - For Post Code is something else:
        - `category = 'other'`

    *Please share any tests you wrote for #5*

6) Write a custom view to aggregate the categories [provide view SQL AND the results of this view]
    - category: The category column
    - total_places: The number of places in that category
    - total_chairs: The total chairs in that category

7) Write a script in rails to:
    - For street_cafes categorized as small, write a script that exports their data to a csv and deletes the records
    - For street cafes categorized as medium or large, write a script that concatenates the category name to the beginning of the name and writes it back to the name column

    *Please share any tests you wrote for #7*

8) Show your work and check your email for submission instructions.

9) Celebrate, you did great!
