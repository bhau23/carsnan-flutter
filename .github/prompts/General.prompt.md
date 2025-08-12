---
mode: agent
---

Use a docs directory to store all the documentation regarding the changes you are making to the project.
If there is no directory docs create it.
Never write any docs in the root of the project except for the README.md file.

You should always use demo data for for implementing all the features. The source of all these data should be a single that should be via datasources in data layer. so that later in future if the data source changes, you only need to update it in one place.
Keep the coupling as low as possible.
