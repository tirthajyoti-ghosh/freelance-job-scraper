[![Run on Repl.it](https://repl.it/badge/github/tirthajyoti-ghosh/freelance-job-scraper)](https://repl.it/github/tirthajyoti-ghosh/freelance-job-scraper)

# Freelance Job Scraper

> Ruby Capstone Project of Microverse, which students have to complete a real-world-like project within 72 hours according to [this project specifications](https://www.notion.so/microverse/Build-your-own-scraper-f54eaca54d8a4d758a5f0141468127a8)

This web scraper is a freelance job scraper that scrapes freelance jobs from these three websites: `freelancer.com`, `guru.com`, `peopleperhour.com` with keywords taken from the user input and exports them to 3 separate CSV files.

![demo-image](https://user-images.githubusercontent.com/57726348/77246333-4b02a400-6c4c-11ea-89e1-5a32c81321b9.png)

## Built With

- Ruby
- Nokogiri gem
- HTTParty gem

## Project Structure

```
├── README.md
├── bin
│   └── main.rb
└── lib
    └── scraper.rb
    └── csv_exporter.rb
└── rspec
    └── scraper_spec.rb
    └── csv_exporter_spec.rb
    └── spec_helper.rb
```

## Video Presentation

Feel free to check out this [link](https://www.loom.com/share/7e4744e6ccd84860858f4be44fc3f212) for a 5min video walkthrough :)

## Deployment

1) Git clone this repo and cd the to the `freelance-job-scraper` directory.
2) Run `bundle install` in command line to install Nokogiri and HTTParty Gem.
3) Run `ruby bin/main.rb`.
4) Input keywords in separate lines. Press enter key on a new line to begim the search.
5) Tada! 'freelancer.com-jobs.csv', 'guru.com-jobs.csv', and 'peopleperhour.com-jobs.csv' would be created at the root directory respectively :)

## Run tests

1) Git clone this repo and cd the to the `freelance-job-scraper` directory.
2) Install rspec with `gem install rspec`.
3) Run `rspec` in Command Line.
4) `15 examples, 0 failures` will be shown on the screen.

## Future releases
- User can select which sites they want to scrape
- Add more sites for scraping
- User can specify how many jobs he/she wants to scrape

## Author

👤 **Tirthajyoti Ghosh**

- Github: [@tirthajyoti-ghosh](https://github.com/tirthajyoti-ghosh)
- Twitter: [@terrific_ghosh](https://twitter.com/terrific_ghosh)
- Linkedin: [Tirthajyoti Ghosh](https://www.linkedin.com/in/tirthajyoti-ghosh/)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](https://github.com/tirthajyoti-ghosh/freelance-job-scraper/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc).

## Show your support

Give a ⭐️ if you like this project!

## Acknowledgments

- Microverse
- Nokogiri gem
- HTTParty Parser
- Freelancer.com
- Guru.com
- Peopleperhour.com

## 📝 License

This project is [MIT](lic.url) licensed.
