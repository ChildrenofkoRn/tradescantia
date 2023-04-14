# Tradescantia
[![badge-license][badge-license]][license]
[![badge-github-pr][badge-github-pr]][github-pr]
[![badge-github-release][badge-github-release]][github-release]
[![badge-tests][badge-tests]][github-workflow]

### Tradescantia - portfolio project on Rails

**BDD development using rspec.**

Agile with User stories: [Pivotal Tracker][tracker]

**Currently implemented:**
- Controller (base actions CRUD) and model Review
- User is the author of his reviews (Authorable Concern & tests w with_model)
- A simple UI based on Bootstrap
- Authentication
- OmniAuth via Github
- Rating for reviews (Ranked Concern & Anonymous Controller tests)
- Authorization w pundit
- Pagination
- Mailing service Daily digest of top reviews
- Github Actions
- Search via Sphinx w real time indexing

**Upcoming plans:**
- ActionCable for review's index
- Simple API
- Dashboard
- Badges
- Search via ElasticSearch
- 

### About

![tradescantia](docs/readme-tradescantia-pink-hill.gif "Tradescantia Pink Hill")

[tracker]: https://www.pivotaltracker.com/n/projects/2631941


[badge-license]: https://img.shields.io/github/license/ChildrenofkoRn/tradescantia?color=%232e9393 "license"
[license]: https://github.com/ChildrenofkoRn/tradescantia/blob/main/LICENSE "license"

[badge-github-pr]: https://img.shields.io/github/issues-pr-closed/ChildrenofKoRn/tradescantia?color=a063dd "count prs"
[github-pr]: https://github.com/ChildrenofkoRn/tradescantia/pulls "prs"

[badge-github-release]: https://img.shields.io/github/v/release/ChildrenofkoRn/tradescantia "current release"
[github-release]: https://github.com/ChildrenofkoRn/tradescantia/releases "releases"

[badge-tests]: https://img.shields.io/github/actions/workflow/status/ChildrenofkoRn/tradescantia/main_ror_rspec.yml?label=tests&branch=main&color=22c39e "tests status"
[github-workflow]: https://github.com/ChildrenofkoRn/tradescantia/actions/workflows/main_ror_rspec.yml "rspec workflow"
