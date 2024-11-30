//
//  DBHeroes_ReactivoTests.swift
//  DBHeroes-ReactivoTests
//
//  Created by Diego Herreros Parron on 23/11/24.
//
import Combine
import KcLibrarySwift1
import CombineCocoa
import UIKit
import XCTest

@testable import DBHeroes_Reactivo

final class DBHeroes_ReactivoTests: XCTestCase {
    
    
    // MARK: - LOGIN TESTS
   
    
    func testLoginFake() async throws {
        let KC = KeyChainKc()
        XCTAssertNotNil(KC)
        
        
        let obj = LoginUseCaseFake()
        XCTAssertNotNil(obj)
        
        // login
        let loginDo = try await obj.login(user: "", password: "")
        XCTAssertEqual(loginDo, true)
        let jwt = KC.loadKC(key:CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")
        
    }
    
    func testLoginReal() async throws  {
        let CK = KeyChainKc()
        XCTAssertNotNil(CK)
        //reset the token
        CK.saveKC(CONST_TOKEN_ID_KEYCHAIN, value: "")
        
        //Caso se uso con repo Fake
        let userCase = LoginUseCase(repo: LoginRepositoryFake())
        XCTAssertNotNil(userCase)
        
        //login
        let loginDo = try await userCase.login(user: "", password: "")
        XCTAssertEqual(loginDo, true)
        let jwt = CK.loadKC(key:CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")
    }
    
    func testLoginFailure() async throws {
          // Arrange
          let network = LoginNetwork() // Usamos el network real
          let username = "wrongUser"
          let password = "wrongPassword"
          
          // Act & Assert
          do {
              _ = try await network.login(username: username, password: password)
          } catch let error {
              // Verificar el tipo de error lanzado
              print(error)
              XCTAssertTrue(error is AppError)
          }
      }
    
    func testLoginAutoLoginAsincrono()  throws  {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Login Auto ")
        
        let vm = LoginViewModel(loginUseCase: LoginUseCaseFake())
        XCTAssertNotNil(vm)
        
        vm.$statusLogin
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("finalizado")
                }
            } receiveValue: { estado in
                print("Recibo estado \(estado)")
                if estado == .none {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)
        
        
        self.waitForExpectations(timeout: 10)
    }
    
    func testUILoginViewViewCotroller()  throws  {
        
        let view = LoginViewController(viewModel: LoginViewModel(loginUseCase: LoginUseCaseFake()))
        view.loadViewIfNeeded()
        
        XCTAssertNotNil(view)
        XCTAssertNoThrow(view)
        
        // el binding
        XCTAssertNoThrow(view.bindingUI())
        
        view.userName?.text = "Hola"
        
        //el boton debe estar desactivado
        XCTAssertEqual(view.userName?.text, "Hola")
        
        view.password?.text = "123456"
        
        XCTAssertEqual(view.password.text, "123456")
        
    }
    
    func testLogin_Data() async throws  {
        let network = NetworkLoginFake()
        XCTAssertNotNil(network)
        
        let repo = DefaultLoginRepository(network: network)
        XCTAssertNotNil(repo)
        let repo2 = LoginRepositoryFake()
        XCTAssertNotNil(repo2)
        
        let token = try await repo.login(user: "goku", password: "123456")
        XCTAssertNotNil(token)
        print(token)

       }
       
       func testLoginSuccessWithFakeUseCase() async throws {
           // Configuración: Usa el caso de uso fake
           let loginUseCaseFake = LoginUseCaseFake()
           let viewModel = LoginViewModel(loginUseCase: loginUseCaseFake)
           
           // Espera
           let expectation = XCTestExpectation(description: "Status should be success after login")
           
           // Ejecutar la función de login
           viewModel.login(username: "testUser", password: "testPassword")
           
           // Validación asincrónica
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               XCTAssertEqual(viewModel.statusLogin, .success)
               expectation.fulfill()
           }
           
           // Espera que la expectativa se cumpla
           await fulfillment(of: [expectation], timeout: 2.0)
       }
       
    // MARK: - HEROES TESTS
    
    func testHeroesViewModel() async throws  {
        let vm = HeroesViewModel(useCaseHeroes: HeroesUseCaseFake())
        XCTAssertNotNil(vm)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(vm.heroesList.count, 2)
        }
        print(vm.heroesList.count)
    }
    
    func testHerosUseCase() async throws  {
        let caseUser = HeroesUseCase(repo: HerosRepositoryFake())
        XCTAssertNotNil(caseUser)
        
        let data = try await caseUser.getHeroes(heroes: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
        
    }
    
    func testHeros_Combine() async throws  {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Heros get")
        
        let vm = HeroesViewModel(useCaseHeroes: HeroesUseCaseFake())
        XCTAssertNotNil(vm)
        
        vm.$heroesList
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("finalizado")
                }
            } receiveValue: { data in
      
                if data.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)
      
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    func testHeros_Data() async throws  {
        let network = NetworkHerosFake()
        XCTAssertNotNil(network)
        let repo = HeroesRepository(network: network)
        XCTAssertNotNil(repo)
        
        let repo2 = HerosRepositoryFake()
        XCTAssertNotNil(repo2)
        
        let data = try await repo2.getHeroes(heroes: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
        
        
        let data2 = try await repo2.getHeroes(heroes: "")
        XCTAssertNotNil(data2)
        XCTAssertEqual(data2.count, 2)
    }
    
    func testHeros_Domain() async throws  {
       //Models
        let model = HeroesModel(favorite: true, description: "true", id: "des", name: "goku", photo: "photo")
        XCTAssertNotNil(model)
        XCTAssertEqual(model.name, "goku")
        XCTAssertEqual(model.favorite, true)
        
        let requestModel = HeroModelRequest(name: "goku")
        XCTAssertNotNil(requestModel)
        XCTAssertEqual(requestModel.name, "goku")
    }
    
    func testHeros_Presentation() async throws  {
        let viewModel = HeroesViewModel(useCaseHeroes: HeroesUseCaseFake())
        XCTAssertNotNil(viewModel)
        
        
    }

    
    // MARK: - DETAIL TESTS
    
    func testDetailHeroesViewModel() async throws {
        let model = HeroesModel(favorite: true, description: "true", id: "des", name: "goku", photo: "photo")
        let viewModel = DetailHeroesViewModel(hero: model , useCase: DetailUseCaseFake())
        XCTAssertNotNil(viewModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(viewModel.transformation.count, 2)
        }
        
        print(viewModel.transformation.count)
    }
    
    func testDetailUseCase() async throws  {
        let caseUser = DetailUseCase(repo: HeroesDetailRepositoryFake())
        XCTAssertNotNil(caseUser)
        
        let data = try await caseUser.gettransformations(id: "id")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
    }
    
    func testDetailHeroes_Combine() async throws  {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Detail get")
        
        let vm = DetailHeroesViewModel(hero: HeroesModel(favorite: true, description: "true", id: "des", name: "goku", photo: "photo"), useCase: DetailUseCaseFake())
        XCTAssertNotNil(vm)
        
        vm.$transformation
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("finalizado")
                }
            } receiveValue: { data in
      
                if data.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)
      
        
        await fulfillment(of: [exp], timeout: 10)
    }
    
    
    func testDidSelectRowNavigatesToDetailScreen() {
        // Configuramos el ViewModel con datos para la tabla
        let viewModel = HeroesViewModel()
        viewModel.heroesList = [HeroesModel(favorite: true, description: "Man of Steel", id: "12345678", name: "superman", photo: "photo")]
        
        let sut = HeroesTableViewController(viewModel: viewModel)
        
        sut.loadViewIfNeeded()

        let navigationController = UINavigationController(rootViewController: sut)
        
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        
        XCTAssertTrue(navigationController.viewControllers.last is DetailHeroesViewController)
    }
    
}
