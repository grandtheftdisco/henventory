# 🐣 Welcome to Henventory!
- This is my first-ever web app: built in Ruby on Rails, styled with Tailwind, and lightly seasoned with Stimulus.js
- If you're here for my portfolio, check out the Process section below for a look behind the scenes!

## ⏲️ Elevator Pitch
- Henventory helps chicken farmers keep track of egg production.
- Whether you have a small backyard flock or several dozen hens, Henventory will answer questions like:
  - How many eggs do I get per day, on average? Does it change with the seasons?
  - Do my Rhode Island Reds lay more than my Barred Rocks?
  - Whcih of my chickens is Employee of the Month?
 
## 👀 See It in Action!
Go check out [Henventory](https://www.henventory.com) in production!
- *-slaps hood-* She's in alpha[^1], folks, so go easy on her.

## 💻 How to Run Henventory Locally
1. clone as per usual
2. [install Rails 8](https://guides.rubyonrails.org/install_ruby_on_rails.html) if you don't already have it
3. in your terminal, navigate to the root dir and run `bin/rails server`
4. then, visit `localhost:3000` in your browser
5. from there, you'll be able to explore the public side of Henventory
6. to get the full experience, sign up for an account in dev

- *full how-to guide coming soon!*
- run into any snags? [Gimme a shout](mailto:grandtheftdisco@gmail.com) or submit an [Issue](https://github.com/grandtheftdisco/henventory/issues)

[^1]: I don't have all of the data-analysis tools up and running yet; we're growing a nice crop of data this spring so we've got something to work with in beta development!

______________________________________________________________________________
______________________________________________________________________________
______________________________________________________________________________

# ⚒️ PROCESS ⚒️

## Goals
- The goal of this project was, primarily, to help my family.
- The other goal was more technical: to learn Rails.
  - Tutorials are great, but what better way to learn than to build something?
 
## Team
- I could **never** call this a solo project and be able to sleep at night.
- My technical mentor Bookis has been indispensable throughout the process.

## Stack
- Ruby on Rails | Stimulus.js | Tailwind
  - Development DB: SQLite
  - Production DB: Postgres[^2]
- Deployment platform: Render

## Timeframe
- alpha: January - March 2025
- beta: *in development*

## Outcomes
- I have two loyal users: the people I built this app for.
  - My main motivation for building this app was to make their lives easier, so any other users -- or anything else I've learned along the way -- well, that's just lagniappe[^3].
 
[^2]: Remind me to *start* with Postgres next time.
[^3]: (pronounced '*LAN-yap*' -- Cajun for "extra stuff" )

## What I Learned

### > Technical Skills
- Most obviously, I familiarized myself with the basics of Ruby on Rails: and I fell in love with it.
- I also strengthened my git and GitHub workflow muscles.
  - Before this project, I was just pushing upstream from `main`[^4].
- Reading documentation: I used to dread it, but now it's one of the first places I look.
- I got comfortable with the MVC pattern.
  - I thought that I could just read about it and get it, but it didn't fully click until I immersed myself in it.
  - Now, I feel empowered to learn other MVC frameworks in the future[^5].
- I learned a _lot_ about how to work with timestamps, which is not something that I expected to be difficult.
  - The most interesting challenge here was learning how to sort instances by their timestamps with consideration to the user's own time zone (instead of sorting by the database default-- UTC).
- I learned how to debug: a skill which is second only to knowing how to write code without any bugs[^6].
- I learned the joys[^7] of switching DBMSs in order to deploy.
- I learned how to write & submit PRs.
  - I've always enjoyed writing, so this was a great chance to exercise these skills in a new environment.
- I started using kanban boards to track my projects instead of using pen & paper[^8].

### > My Favorite Parts of Learning Rails
- Getting acquainted with Active Record query interface
- Determining what to abstract out of the views
- Generally, anything towards the back of the stack

### > My Biggest Challenges
- Timestamps and time zone conversion, hands down.
- Route customization (vanity URLs, parameters, instance ids)
- UI design[^9]

### > What did I learn in a holistic sense?
- I learned how to wrestle with difficult problems, and how to be frustrated.
  - I cannot stress enough how valuable it was for me to learn how to be frustrated, and how to sit with a problem that was unsolved[^10].
- In turn, I learned when to push through a problem, and when to take a step back to let some subconscious wrestling happen[^11].
- I learned how & when to ask for help (no one is an island!), and likewise, when to push myself to find the answers independently.
- On that note, I learned how to develop without AI.
  - This was a big one for me, and maybe a bit controversial, too.
  - I think there's a time and a place to use assistants and/or agents, but I wanted to go through the process, start to finish, with only human brains involved. I'm very glad I did.
- I learned how to put my big, looming, often-foggy questions into words.
  - This is one of the most challenging aspects of software development: knowing how to ask a question without having a paradigm in place _for_ that question. In other words: it's hard to ask about something that you don't yet understand.

**Most importantly:** I would not have learned any of these things without Bookis' technical guidance and touchbase meetings. Seriously. After this experience, I firmly believe that good development cannot be done in a vacuum. While Rails may be known as 'the one-person framework', I would truly hate to be forced to use it that way. 
 
[^4]: I, too, like to live dangerously.
[^5]: I'm looking at you, Laravel.
[^6]: Anyone got this figured out yet?
[^7]: Again: remind me to just _start_ with Postgres next time.
[^8]: I am decidedly low-tech in my personal life, so this felt Herculean to accomplish.
[^9]: Don't get me wrong, I can do this. I just know that there are people out there who were straight-up _born_ to do it, and who would run perfectly centered and drop-shadowed circles around me. I have the utmost respect for my siblings on the front-end.
[^10]: At least temporarily: I stubbornly refuse to give up on any bugs.
[^11]: Cal Newport's book _Deep Work_ has been my north star here. Daily walks through the garden abound.

______________________________________________________________________________
______________________________________________________________________________
______________________________________________________________________________

# 👷‍♀️WHAT I'D DO DIFFERENTLY THE 2nd TIME AROUND 👷‍♀️
*coming soon!*
