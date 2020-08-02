//
//  DetailsViewControllerTest.swift
//  MoviesTests
//
//  Created by Douglas Hennrich on 02/08/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

@testable import Movies
import XCTest

// swiftlint:disable force_try
class DetailsViewControllerTest: XCTestCase {

    // MARK: Properties
    var sut: DetailsViewController!
    var movie: MovieViewModel!
    let favoritesManager = FavoritesManager.shared
    
    // MARK: Life cycle
    override func setUpWithError() throws {
        sut = DetailsViewController.instantiateFromStoryboard(named: "Details")
        
        movie = {
            let jsonData = loadSub(name: "MockMoviesResponse", extensionName: "json")
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let selectedMovie = try! decoder.decode(Movies.self, from: jsonData).results.first!
            
            return MovieViewModel(movie: selectedMovie)
        }()
        
        favoritesManager.setUpTestList()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        movie = nil
        favoritesManager.tearDownTestList()
    }
    
    // MARK: Tests
    func test_should_first_cell_be_generic_type() {
        let expectation = XCTestExpectation(description: "Set info from movie")
        let viewModel = DetailsViewModelTest(movie: movie,
                                             expectation: expectation)
        sut.viewModel = viewModel
        sut.viewDidLoad()
        
        let cell = sut.tableView.cellForRow(at: IndexPath(row: 0,
                                                          section: 0)) as? GenericTableViewCell
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssert(cell != nil,
                  "Primeira celula da tabela deve ser da classe GenericTableViewCell")
    }
    
    func test_should_save_to_favorites() {
        let expectation = XCTestExpectation(description: "Set info from movie")
        expectation.expectedFulfillmentCount = 2
        
        let viewModel = DetailsViewModelTest(movie: movie,
                                             expectation: expectation)
        sut.viewModel = viewModel
        sut.viewDidLoad()
        
        sut.onFavoriteButton()
        
        wait(for: [expectation], timeout: 5)
        
        guard let data = UserDefaults.standard.value(forKey: "favoritesListTest") as? Data,
            let favorites = try? JSONDecoder().decode([MovieViewModel].self, from: data)
            else {
                fatalError()
        }
        
        XCTAssert(favorites.count == 1, "Deve conter um favorito salvo")
    }

}
