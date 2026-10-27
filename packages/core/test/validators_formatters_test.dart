import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SimValidatorless', () {
    test('cnpj aceita válidos e recusa dígito errado ou repetido', () {
      expect(SimValidatorless.cnpjValido('11.222.333/0001-81'), isTrue);
      expect(SimValidatorless.cnpjValido('11222333000181'), isTrue);
      expect(SimValidatorless.cnpjValido('11.222.333/0001-82'), isFalse);
      expect(SimValidatorless.cnpjValido('11.111.111/1111-11'), isFalse);
      expect(SimValidatorless.cnpj()(''), isNull);
    });

    test('obrigatório, e-mail, CEP e telefone', () {
      expect(SimValidatorless.obrigatorio()('  '), 'Campo obrigatório');
      expect(SimValidatorless.email()('compras@empresa.com.br'), isNull);
      expect(SimValidatorless.email()('compras@'), 'E-mail inválido');
      expect(SimValidatorless.cep()('27250-000'), isNull);
      expect(SimValidatorless.cep()('2725'), 'CEP inválido');
      expect(SimValidatorless.telefone()('(24) 3342-6057'), isNull);
      expect(SimValidatorless.telefone()('(24) 99256-9778'), isNull);
      expect(SimValidatorless.telefone()('3342-6057'), 'Telefone inválido');
    });

    test('múltiplos retorna o primeiro erro', () {
      final validador = SimValidatorless.multiplos([SimValidatorless.obrigatorio(), SimValidatorless.cnpj()]);
      expect(validador(''), 'Campo obrigatório');
      expect(validador('123'), 'CNPJ inválido');
    });
  });

  group('MaskInputFormatter', () {
    test('formata CNPJ, CEP e telefone fixo ou celular', () {
      expect(MaskInputFormatter.cnpj().formatar('11222333000181'), '11.222.333/0001-81');
      expect(MaskInputFormatter.cep().formatar('27250000'), '27250-000');
      expect(MaskInputFormatter.telefone().formatar('2433426057'), '(24) 3342-6057');
      expect(MaskInputFormatter.telefone().formatar('24992569778'), '(24) 99256-9778');
      expect(MaskInputFormatter.cnpj().formatar('112'), '11.2');
    });
  });

  test('normalizado remove acentos e maiúsculas', () {
    expect('Metalúrgica São João'.normalizado, 'metalurgica sao joao');
  });

  test('UnidadeFederativa encontra por sigla ou nome', () {
    expect(UnidadeFederativa.de('rj'), UnidadeFederativa.rj);
    expect(UnidadeFederativa.de('Rio de Janeiro'), UnidadeFederativa.rj);
    expect(UnidadeFederativa.de('XX'), isNull);
  });
}
