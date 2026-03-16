# Contributing to Recall

Thank you for your interest in contributing to Recall! This document provides guidelines and best practices for contributing to the project.

## 🎯 Project Goals

Recall serves as:

- **Dart on the Server Showcase**: Demonstrates full-stack Dart development with multiple backend implementations
- **Educational Resource**: Teaches full-stack Dart development
- **Reference Implementation**: Provides a working example of a complete full-stack Dart application

## 🚀 Getting Started

### Prerequisites

- [Dart SDK](https://dart.dev/get-dart) ^3.9.0
- [Flutter SDK](https://flutter.dev/docs/get-started/install) ^3.9.0
- [Git](https://git-scm.com/)
- [Dart Frog CLI](https://dartfrog.vgv.dev/docs/getting-started/installation) (for backend development)

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/recall.git
   cd recall
   ```

2. **Install Dependencies**
   ```bash
   # Install all dependencies at once (pub workspaces resolves all packages)
   dart pub get
   ```

3. **Set Up Environment**
   ```bash
   # Copy environment template
   cp apps/backend/env.example apps/backend/.env
   # Edit with your OAuth credentials
   ```

4. **Generate Code**
   ```bash
   # Generate code for each package
   cd apps/backend && dart run build_runner build && cd ../..
   cd packages/common && dart run build_runner build && cd ../..
   ```

5. **Run Tests**
   ```bash
   # Run tests for each package
   cd apps/backend && dart test && cd ../..
   cd apps/frontend && flutter test && cd ../..
   cd packages/common && dart test && cd ../..
   ```

## 🔄 Development Workflow

### Branch Strategy

- `main` - Production-ready code
- `staging` - Integration branch for testing
- `feature/*` - Feature development branches
- `bugfix/*` - Bug fix branches
- `docs/*` - Documentation updates

### Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(auth): add GitHub OAuth integration
fix(notes): resolve note deletion issue
docs(readme): update setup instructions
```

### Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Make Changes**
   - Write clean, well-documented code
   - Add tests for new functionality
   - Update documentation as needed

3. **Test Your Changes**
   ```bash
   # Run all tests
   dart test
   
   # Run specific tests
   dart test apps/backend/test/
   flutter test apps/frontend/test/
   ```

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat(notes): add note sharing functionality"
   ```

5. **Push and Create PR**
   ```bash
   git push origin feature/amazing-feature
   ```

6. **Create Pull Request**
   - Use the PR template
   - Link related issues
   - Request reviews from maintainers

## 📝 Code Standards

### Dart/Flutter Standards

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use [Very Good Analysis](https://pub.dev/packages/very_good_analysis) (backends) or [lints](https://pub.dev/packages/lints) (frontend/packages) for static analysis
- Maintain test coverage above 80%
- Write meaningful commit messages

### Backend Standards

- Use [Dart Frog](https://dartfrog.vgv.dev/) or [Shelf](https://pub.dev/packages/shelf) best practices
- Follow RESTful API design principles
- Implement proper error handling
- Add comprehensive tests

### Frontend Standards

- Follow Flutter best practices
- Use [Riverpod](https://riverpod.dev/) for state management
- Implement responsive design
- Ensure accessibility compliance

### Common Package Standards

- Keep models immutable
- Include validation for DTOs
- Use code generation for serialization
- Document all public APIs

## 🧪 Testing

### Test Requirements

- **Unit Tests**: Test individual functions and methods
- **Widget Tests**: Test Flutter widgets
- **Integration Tests**: Test API endpoints
- **Coverage**: Maintain >80% test coverage

### Running Tests

```bash
# All tests
dart test

# Backend tests
cd apps/backend && dart test

# Frontend tests
cd apps/frontend && flutter test

# Common package tests
cd packages/common && dart test
```

### Writing Tests

```dart
// Example unit test
test('should create note with valid data', () {
  final params = CreateNoteParams(
    title: 'Test Note',
    content: 'Test content',
  );
  
  expect(params.title, equals('Test Note'));
  expect(params.content, equals('Test content'));
});
```

## 📚 Documentation

### Documentation Standards

- Update README files for significant changes
- Document new API endpoints
- Include code examples
- Keep documentation up-to-date

### Required Documentation Updates

- **New Features**: Update relevant README files
- **API Changes**: Update API documentation
- **Setup Changes**: Update setup instructions
- **Breaking Changes**: Update migration guides

## 🐛 Bug Reports

### Before Reporting

1. Check existing issues
2. Try the latest version
3. Reproduce the issue
4. Check documentation

### Bug Report Template

```markdown
## Bug Description
Brief description of the bug

## Steps to Reproduce
1. Go to '...'
2. Click on '....'
3. See error

## Expected Behavior
What you expected to happen

## Actual Behavior
What actually happened

## Environment
- OS: [e.g., macOS, Windows, Linux]
- Dart Version: [e.g., 3.9.0]
- Flutter Version: [e.g., 3.9.0]

## Additional Context
Any other relevant information
```

## ✨ Feature Requests

### Feature Request Template

```markdown
## Feature Description
Brief description of the feature

## Use Case
Why is this feature needed?

## Proposed Solution
How should this feature work?

## Alternatives Considered
Other solutions you've considered

## Additional Context
Any other relevant information
```

## 🔒 Security

### Security Guidelines

- **Never commit secrets**: Use environment variables
- **Report vulnerabilities**: Email developerjamiu@gmail.com
- **Follow OWASP guidelines**: For web security
- **Validate inputs**: Always validate user inputs

### Reporting Security Issues

For security vulnerabilities, please email developerjamiu@gmail.com instead of creating a public issue.

## 🏷️ Release Process

### Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Checklist

- [ ] All tests pass
- [ ] Documentation updated
- [ ] Version bumped
- [ ] Release notes prepared

## 🤝 Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Provide constructive feedback
- Focus on the issue, not the person

### Getting Help

- **Documentation**: Check README files first
- **Issues**: Create GitHub issues for bugs/features
- **Email**: Contact [developerjamiu@gmail.com](mailto:developerjamiu@gmail.com)

## 📋 Issue Labels

We use the following labels for issues:

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements to documentation
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention is needed
- `question` - Further information is requested
- `wontfix` - This will not be worked on

## 🎉 Recognition

Contributors will be recognized in:

- CONTRIBUTORS.md file
- Release notes
- Project documentation

## 📄 License

By contributing to Recall, you agree that your contributions will be licensed under the MIT License.

## 📞 Contact

- **Email**: [developerjamiu@gmail.com](mailto:developerjamiu@gmail.com)
- **GitHub**: [@developerjamiu](https://github.com/developerjamiu)

Thank you for contributing to Recall! 🚀
