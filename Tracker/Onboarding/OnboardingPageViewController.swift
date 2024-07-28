//
//  Onboarding.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 28.07.2024.
//

import Foundation

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    lazy var pages: [UIViewController] = {
        let onboardingViewController1 = OnboardingViewController(backgroundImage: UIImage(named: "onboardingBackground1") ?? UIImage(), onboardingText: "Отслеживайте только то, что хотите")
        let onboardingViewController2 = OnboardingViewController(backgroundImage: UIImage(named: "onboardingBackground2") ?? UIImage(), onboardingText: "Даже если это не литры воды и йога")
        
        return [onboardingViewController1, onboardingViewController2]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(named: "darkGray")
        pageControl.pageIndicatorTintColor = UIColor(named: "darkGray")?.withAlphaComponent(30)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var startButton: UIButton = {
        let startButton = UIButton(type: .system)
        startButton.setTitle("Вот это технологии!", for: .normal)
        startButton.tintColor = .white
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.layer.cornerRadius = 16
        startButton.backgroundColor = UIColor(named: "darkGray")
        startButton.translatesAutoresizingMaskIntoConstraints = false
        return startButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(pageControl)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -24),
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            startButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func startButtonTapped() {
        feedbackGenerator.impactOccurred()
        if let appDelegation = UIApplication.shared.delegate as? AppDelegate {
            appDelegation.didFinishOnboarding()
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
