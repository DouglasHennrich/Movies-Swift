//
//  HomeViewControllerTest.swift
//  MoviesTests
//
//  Created by Douglas Hennrich on 01/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import XCTest
@testable import Movies

class HomeViewControllerTest: XCTestCase {

    // MARK: Properties
    var sut: HomeViewController!
    
    // MARK: Life cycle
    override func setUpWithError() throws {
        sut = HomeViewController.instantiateFromStoryboard(named: "Home")
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: Tests
    func test_should_have_at_least_one_movie() {
        let expectation = XCTestExpectation(description: "getMovies()")
        let viewModel = HomeViewModelTest(expectation: expectation)
        sut.viewModel = viewModel
        sut.viewDidLoad()
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssert(viewModel.movies.value.count >= 1,
                      "Deve conter ao menos 1 movie")
    }
    
    func test_should_have_at_least_one_highlight() {
        let expectation = XCTestExpectation(description: "getMovies() + highlight")
        let viewModel = HomeViewModelTest(expectation: expectation)
        sut.viewModel = viewModel
        sut.viewDidLoad()
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssert(viewModel.highlights.count >= 1,
                      "Deve conter ao menos 1 highlight")
    }
    
    func test_should_present_error_message() {
        let expectation = XCTestExpectation(description: "getMovies() + Error message")
        let viewModel = HomeViewModelTest(expectation: expectation)
        viewModel.apiShouldFail = true
        
        sut.viewModel = viewModel
        sut.viewDidLoad()
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssert(viewModel.error.value == ServiceError.badRequest.message,
                      "Deve conter a mensagem de erro de 'badRequest'")
    }

    func test_should_first_cell_on_first_section_from_tableView_be_highlight_type() {
        let expectation = XCTestExpectation(description: "getMovies()")
        let viewModel = HomeViewModelTest(expectation: expectation)
        sut.viewModel = viewModel
        sut.viewDidLoad()
        
        let cell = sut.tableView.cellForRow(at: IndexPath(row: 0,
                                                          section: 0)) as? HighlightTableViewCell
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssert(cell != nil,
                  "Primeira celula da tabela na primeira section deve ser da classe HighlightTableViewCell")
    }
    
    func test_should_first_cell_on_secondt_section_from_tableView_be_movies_type() {
        let expectation = XCTestExpectation(description: "getMovies()")
        let viewModel = HomeViewModelTest(expectation: expectation)
        sut.viewModel = viewModel
        sut.viewDidLoad()
        
        let cell = sut.tableView.cellForRow(at: IndexPath(row: 0,
                                                          section: 1)) as? MovieTableViewCell
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssert(cell != nil,
                  "Primeira celula da tabela na segunda section deve ser da classe MovieTableViewCell")
    }
    
}
